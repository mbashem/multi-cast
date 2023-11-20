import 'package:flutter/material.dart';
import 'package:flutter_app/src/meeting/services/p2p_meeting_service.dart';
import 'package:flutter_app/src/meeting/meeting_video_widget.dart';

class MeetingWidget extends StatelessWidget {
  final String userId;
  final String name;
  final P2PMeetingService p2pMeetingService;

  const MeetingWidget(
      {super.key,
      required this.userId,
      required this.name,
      required this.p2pMeetingService});

  @override
  Widget build(BuildContext context) {
    return MeetingVideoWidget(
        videoRenderer: p2pMeetingService.remoteVideoRenderer,
        userName: name,
        isMicMuted: false,
        isCameraMuted: false);
  }
}
