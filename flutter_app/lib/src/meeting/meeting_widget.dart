import 'package:flutter/material.dart';
import 'package:flutter_app/src/meeting/services/p2p_meeting_service.dart';
import 'package:flutter_app/src/meeting/video_overlay.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: SizedBox(
            height: 210,
            // child: Flexible(
            child: VideoOverlay(
                videoRenderer: p2pMeetingService.remoteVideoRenderer,
                userName: name,
                isMicMuted: false,
                isCameraMuted: false)
            // ),
            ));
  }
}
