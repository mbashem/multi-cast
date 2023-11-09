import 'package:flutter/material.dart';
import 'package:flutter_app/src/meeting/meeting_widget.dart';
import 'package:flutter_app/src/meeting/models/meeting_event.dart';
import 'package:flutter_app/src/meeting/services/p2p_meeting_service.dart';
import 'package:flutter_app/src/utils/logger.dart';
import 'package:flutter_app/src/utils/random.dart';
import 'package:flutter_app/src/utils/urls.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class MeetingPage extends StatefulWidget {
  static const routeName = '/meeting';

  const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final io.Socket socket = io.io(socketURL, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  String sessionId = "";
  final room = "42";
  final name = getRandomString(5);
  final List<MeetingWidget> meetingWidgets = [];
  P2PMeetingService p2pMeetingService = P2PMeetingService(
    room: "42",
    name: getRandomString(5),
  );

  _createMeetingWidget(MeetingEvent data) async {
    var currP2PMeetingService = P2PMeetingService(
      room: room,
      name: getRandomString(5),
      currSessionId: data.to,
      remoteSessionId: data.sender,
    );

    await currP2PMeetingService.init(socket);

    var meetingWidget = MeetingWidget(
        name: data.msg!,
        userId: data.sender!,
        p2pMeetingService: currP2PMeetingService);

    return meetingWidget;
  }

  @override
  void initState() {
    super.initState();
    p2pMeetingService.init(socket);
    socket.connect();

    socket.onConnect((data) {
      socket.emit("joinRoom", MeetingEvent(room: room, msg: name));
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
      logger.i("userInfo");
      data = MeetingEvent.fromJson(data);
      setState(() {
        sessionId = data.msg!;
        logger.i(sessionId);
      });
      logger.i(data);
    });

    socket.on('offer', (data) async {
      data = MeetingEvent.fromJson(data);
      logger.i(data);
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

    socket.on('chat_message', (data) {
      logger.i(data);
    });
  }

  Row offerAndAnswerButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              p2pMeetingService.initOffer();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.amber,
              elevation: 20, // Elevation
              shadowColor: Colors.amber, // Shadow Color
            ),
            child: const Text('Offer'),
          ),
        ],
      );

  SizedBox videoRenderers() => SizedBox(
        height: 210,
        child: Row(children: [
          Flexible(
              child: Container(
            key: const Key('local'),
            margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            decoration: const BoxDecoration(color: Colors.black),
            child: RTCVideoView(p2pMeetingService.localVideoRenderer,
                mirror: true),
          )),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting $sessionId'),
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              offerAndAnswerButtons(),
              videoRenderers(),
              Text("SessionID: $sessionId"),
              Flexible(
                child: ListView.builder(
                  itemCount: meetingWidgets.length,
                  itemBuilder: (context, index) {
                    return meetingWidgets[index];
                  },
                ),
              ),
            ],
          )),
    );
  }
}
