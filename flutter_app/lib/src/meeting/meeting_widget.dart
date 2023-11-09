import 'package:flutter/material.dart';
import 'package:flutter_app/src/meeting/services/p2p_meeting_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class MeetingWidget extends StatelessWidget {
  final String userId;
  final String name;
  final P2PMeetingService p2pMeetingService;

  const MeetingWidget(
      {super.key,
      required this.userId,
      required this.name,
      required this.p2pMeetingService});

  void initState() {
    // p2pMeetingService.init();
  }

  SizedBox videoRenderers() => SizedBox(
        height: 210,
        child: Stack(
          children: [
            // Video view
            Flexible(
              child: Container(
                key: const Key('remote'),
                margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                decoration: const BoxDecoration(color: Colors.black),
                child: RTCVideoView(p2pMeetingService.remoteVideoRenderer),
              ),
            ),
            // Overlay text
            Positioned(
              top: 10.0,
              left: 10.0,
              child: Text(
                userId,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
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
