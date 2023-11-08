import 'package:flutter/material.dart';
import 'package:flutter_app/src/meeting/meeting_widget.dart';
import 'package:flutter_app/src/meeting/services/p2p_meeting_service.dart';
import 'package:flutter_app/src/utils/logger.dart';
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
  P2PMeetingService p2pMeetingService = P2PMeetingService();

  @override
  void initState() {
    super.initState();
    p2pMeetingService.init(socket);

    socket.on("newUser", (data) {
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
          Flexible(
              child: MeetingWidget(
                  p2pMeetingService: p2pMeetingService, userId: "43"))
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting'),
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              offerAndAnswerButtons(),
              videoRenderers(),
            ],
          )),
    );
  }
}
