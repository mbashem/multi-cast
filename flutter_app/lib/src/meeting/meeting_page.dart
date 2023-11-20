import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/auth/auth_service.dart';
import 'package:flutter_app/src/home/home_page.dart';
import 'package:flutter_app/src/meeting/chat_widget.dart';
import 'package:flutter_app/src/meeting/meeting_control_panel.dart';
import 'package:flutter_app/src/meeting/meeting_widget.dart';
import 'package:flutter_app/src/meeting/models/chat_message.dart';
import 'package:flutter_app/src/meeting/models/meeting_event.dart';
import 'package:flutter_app/src/meeting/services/p2p_meeting_service.dart';
import 'package:flutter_app/src/meeting/meeting_video_widget.dart';
import 'package:flutter_app/src/utils/logger.dart';
import 'package:flutter_app/src/utils/random.dart';
import 'package:flutter_app/src/utils/urls.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

@RoutePage()
class MeetingPage extends StatefulWidget {
  static const routeName = '/meeting';

  final String meetingId;

  const MeetingPage({
    super.key,
    @PathParam('meetingId') required this.meetingId,
  });

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  io.Socket? socket;
  String sessionId = "";
  var name = getRandomString(5);
  final List<ChatMessage> messages = [];
  final List<MeetingWidget> meetingWidgets = [];
  bool _isMicOn = true;
  bool _isCameraOn = true;

  final Map<String, String> userName = {};
  MediaStream? localMediaStream;
  final localVideoRenderer = RTCVideoRenderer();

  _getUserMedia() async {
    final Map<String, dynamic> constraints = {
      'audio': _isMicOn,
      'video': {
        'facingMode': 'user',
      },
    };

    try {
      for (var element in meetingWidgets) {
        await element.p2pMeetingService.removeStream(localMediaStream);
      }
      MediaStream stream =
          await navigator.mediaDevices.getUserMedia(constraints);

      setState(() {
        localMediaStream = stream;
        localVideoRenderer.srcObject = stream;
      });
      for (var element in meetingWidgets) {
        await element.p2pMeetingService.addStream(stream);
      }
    } catch (e) {
      logger.i("Failed to get user media: $e");
    }
  }

  _createMeetingWidget(MeetingEvent data) async {
    var currP2PMeetingService = P2PMeetingService(
      room: widget.meetingId,
      currSessionId: data.to,
      remoteSessionId: data.sender,
    );

    await currP2PMeetingService.init(socket!);
    userName[data.sender!] = data.msg!;

    var meetingWidget = MeetingWidget(
        name: data.msg!,
        userId: data.sender!,
        p2pMeetingService: currP2PMeetingService);

    return meetingWidget;
  }

  @override
  initState() {
    super.initState();

    _localInit();
  }

  _localInit() async {
    var jwtToken = await AuthService.getJWTToken();
    socket = io.io(socketURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {
        "token": jwtToken,
      }
    });

    var currName = await AuthService.getUserName() ?? name;
    setState(() {
      name = currName;
    });
    logger.i("token: $jwtToken");

    await localVideoRenderer.initialize();
    _getUserMedia();
    setState(() {
      userName[sessionId] = currName;
    });

    socket!.connect();
    socket!.onConnect((data) {
      socket!.emit(
          "joinRoom", MeetingEvent(room: widget.meetingId, msg: currName));
    });

    socket!.on("newUser", (data) async {
      logger.i("newUser");
      logger.i(data);
      data = MeetingEvent.fromJson(data);

      var meetingWidget = await _createMeetingWidget(data);
      if (localMediaStream != null) {
        meetingWidget.p2pMeetingService.addStream(localMediaStream!);
      }
      {
        setState(() {
          meetingWidgets.add(meetingWidget);
        });
      }
    });

    socket!.on("prvUser", (data) async {
      logger.i("prvUser");
      data = MeetingEvent.fromJson(data);
      logger.i(data);

      var meetingWidget = await _createMeetingWidget(data);
      if (localMediaStream != null) {
        meetingWidget.p2pMeetingService.addStream(localMediaStream!);
      }
      meetingWidget.p2pMeetingService.initOffer();
      setState(() {
        meetingWidgets.add(meetingWidget);
      });
    });

    socket!.on("userDisconnected", (data) {
      logger.i("userDisconnected");
      logger.i(data);
      data = MeetingEvent.fromJson(data);
      setState(() {
        meetingWidgets.removeWhere((element) => element.userId == data.sender);
      });
    });

    socket!.on("userInfo", (data) {
      data = MeetingEvent.fromJson(data);
      setState(() {
        sessionId = data.msg!;
      });
    });

    socket!.on('offer', (data) async {
      data = MeetingEvent.fromJson(data);
      for (var element in meetingWidgets) {
        if (element.userId == data.sender) {
          element.p2pMeetingService.addOffer(data);
        }
      }
    });
    socket!.on('answer', (data) async {
      data = MeetingEvent.fromJson(data);

      for (var element in meetingWidgets) {
        if (element.userId == data.sender) {
          element.p2pMeetingService.addAnswer(data);
        }
      }
    });
    socket!.on('candidate', (data) async {
      data = MeetingEvent.fromJson(data);

      for (var element in meetingWidgets) {
        if (element.userId == data.sender) {
          element.p2pMeetingService.addCandidate(data);
        }
      }
    });

    socket!.on('chatMessage', (data) {
      var recievedChat = MeetingEvent.fromJson(data);
      setState(() {
        messages.add(ChatMessage(
            msg: recievedChat.msg!,
            senderName: userName[recievedChat.sender!] ?? "Unknown"));
      });
    });
  }

  void _hangeUp() async {
    for (var element in meetingWidgets) {
      await element.p2pMeetingService.closeConnection();
    }

    AutoRouter.of(context).replaceNamed(HomePage.routeName);
  }

  @override
  void dispose() {
    super.dispose();
    socket?.dispose();
    messages.clear();
    meetingWidgets.clear();
    localVideoRenderer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double runSpacing = 4;
    double spacing = 4;
    var columns = 2;
    final w = (MediaQuery.of(context).size.width - runSpacing * (columns - 1)) /
        columns;
    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting ${widget.meetingId}'),
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Expanded(
                child: Center(
                    child: SingleChildScrollView(
                  child: Wrap(
                    runSpacing: runSpacing,
                    spacing: spacing,
                    alignment: WrapAlignment.center,
                    children: List.generate(meetingWidgets.length + 1, (index) {
                      return Container(
                        width: w,
                        height: w * 0.8,
                        // color: Colors.green[200],
                        child: ((index == meetingWidgets.length)
                            ? MeetingVideoWidget(
                                isCameraMuted: false,
                                isMicMuted: !_isMicOn,
                                videoRenderer: localVideoRenderer,
                                userName: name,
                                mirror: true,
                              )
                            : meetingWidgets[index]),
                      );
                    }),
                  ),
                )),
              ),
              MeetingControlPanel(
                onToggleAudio: () {
                  setState(() {
                    _isMicOn = !_isMicOn;
                    localMediaStream!.getAudioTracks().forEach((track) {
                      track.enabled = _isMicOn;
                    });
                  });
                },
                onToggleVideo: () {
                  // localMediaStream
                  setState(() {
                    _isCameraOn = !_isCameraOn;
                    localMediaStream!.getVideoTracks().forEach((track) {
                      track.enabled = _isCameraOn;
                    });
                  });
                },
                onHangUp: _hangeUp,
              )
            ],
          )),
      endDrawer: Drawer(
          child: ChatWidget(
        messages: messages,
        sendMessage: (String message) {
          logger.i(message);
          socket!.emit(
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
