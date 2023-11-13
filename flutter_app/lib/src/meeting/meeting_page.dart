import 'package:flutter/material.dart';
import 'package:flutter_app/src/meeting/chat_widget.dart';
import 'package:flutter_app/src/meeting/meeting_control_panel.dart';
import 'package:flutter_app/src/meeting/meeting_widget.dart';
import 'package:flutter_app/src/meeting/models/chat_message.dart';
import 'package:flutter_app/src/meeting/models/meeting_event.dart';
import 'package:flutter_app/src/meeting/services/p2p_meeting_service.dart';
import 'package:flutter_app/src/meeting/video_overlay.dart';
import 'package:flutter_app/src/utils/logger.dart';
import 'package:flutter_app/src/utils/random.dart';
import 'package:flutter_app/src/utils/urls.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class MeetingPage extends StatefulWidget {
  static const routeName = '/meeting';
  final String meetingId;

  const MeetingPage({super.key, required this.meetingId});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final io.Socket socket = io.io(socketURL, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  String sessionId = "";
  final name = getRandomString(5);
  final List<ChatMessage> messages = [];
  final List<MeetingWidget> meetingWidgets = [];
  P2PMeetingService p2pMeetingService = P2PMeetingService(
    room: "42",
  );
  final Map<String, String> userName = {};

  _createMeetingWidget(MeetingEvent data) async {
    var currP2PMeetingService = P2PMeetingService(
      room: widget.meetingId,
      currSessionId: data.to,
      remoteSessionId: data.sender,
    );

    await currP2PMeetingService.init(socket);
    userName[data.sender!] = data.msg!;

    var meetingWidget = MeetingWidget(
        name: data.msg!,
        userId: data.sender!,
        p2pMeetingService: currP2PMeetingService);

    return meetingWidget;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      userName[sessionId] = name;
    });
    p2pMeetingService.init(socket);
    socket.connect();

    socket.onConnect((data) {
      socket.emit("joinRoom", MeetingEvent(room: widget.meetingId, msg: name));
    });

    socket.on("newUser", (data) async {
      logger.i("newUser");
      logger.i(data);
      data = MeetingEvent.fromJson(data);

      var meetingWidget = await _createMeetingWidget(data);
      setState(() {
        meetingWidgets.add(meetingWidget);
      });
    });

    socket.on("prvUser", (data) async {
      logger.i("prvUser");
      data = MeetingEvent.fromJson(data);
      logger.i(data);

      var meetingWidget = await _createMeetingWidget(data);

      meetingWidget.p2pMeetingService.initOffer();
      setState(() {
        meetingWidgets.add(meetingWidget);
      });
    });

    socket.on("userDisconnected", (data) {
      logger.i("userDisconnected");
      logger.i(data);
      data = MeetingEvent.fromJson(data);
      setState(() {
        meetingWidgets.removeWhere((element) => element.userId == data.sender);
      });
    });

    socket.on("userInfo", (data) {
      data = MeetingEvent.fromJson(data);
      setState(() {
        sessionId = data.msg!;
      });
    });

    socket.on('offer', (data) async {
      data = MeetingEvent.fromJson(data);
      for (var element in meetingWidgets) {
        if (element.userId == data.sender) {
          element.p2pMeetingService.addOffer(data);
        }
      }
    });
    socket.on('answer', (data) async {
      data = MeetingEvent.fromJson(data);

      for (var element in meetingWidgets) {
        if (element.userId == data.sender) {
          element.p2pMeetingService.addAnswer(data);
        }
      }
    });
    socket.on('candidate', (data) async {
      data = MeetingEvent.fromJson(data);

      for (var element in meetingWidgets) {
        if (element.userId == data.sender) {
          element.p2pMeetingService.addCandidate(data);
        }
      }
    });

    socket.on('chatMessage', (data) {
      var recievedChat = MeetingEvent.fromJson(data);
      print(recievedChat);
      setState(() {
        messages.add(ChatMessage(
            msg: recievedChat.msg!,
            senderName: userName[recievedChat.sender!] ?? "Unknown"));
      });
    });
  }

  SizedBox videoRenderers() => SizedBox(
        height: 210,
        child: Stack(
          children: [
            VideoOverlay(
              isCameraMuted: false,
              isMicMuted: false,
              videoRenderer: p2pMeetingService.localVideoRenderer,
              userName: name,
              mirror: true,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting ${widget.meetingId}'),
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              videoRenderers(),
              Flexible(
                child: ListView.builder(
                  itemCount: meetingWidgets.length,
                  itemBuilder: (context, index) {
                    return meetingWidgets[index];
                  },
                ),
              ),
              MeetingControlPanel(
                onToggleAudio: () {
                  p2pMeetingService.toggleMic();

                  for (var element in meetingWidgets) {
                    element.p2pMeetingService.toggleMic();
                  }
                },
                onToggleVideo: () {
                  p2pMeetingService.toggleCamera();

                  for (var element in meetingWidgets) {
                    element.p2pMeetingService.toggleCamera();
                  }
                },
                onToggleScreenShare: () {},
                onHangUp: () {},
              )
            ],
          )),
      endDrawer: Drawer(
          child: ChatWidget(
        messages: messages,
        sendMessage: (String message) {
          logger.i(message);
          socket.emit(
              "chatMessage",
              MeetingEvent(
                room: widget.meetingId,
                msg: message,
                sender: sessionId,
              ));
        },
      )),
    );
  }
}
