import 'package:flutter/material.dart';
import 'package:flutter_app/src/meeting/services/p2p_meeting_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class MeetingWidget extends StatelessWidget {
  final String userId;
  final P2PMeetingService p2pMeetingService;

  const MeetingWidget(
      {super.key, required this.userId, required this.p2pMeetingService});

  void initState() {
    // p2pMeetingService.init();
  }

  SizedBox videoRenderers() => SizedBox(
        height: 210,
        child: Row(children: [
          Flexible(
              child: Container(
            key: const Key('remote'),
            margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            decoration: const BoxDecoration(color: Colors.black),
            child: RTCVideoView(p2pMeetingService.remoteVideoRenderer),
          ))
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            videoRenderers(),
          ],
        ));
  }
}
