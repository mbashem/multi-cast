import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/src/meeting/models/user_status_event.dart';
import 'package:flutter_app/src/meeting/services/p2p_meeting_service.dart';
import 'package:flutter_app/src/meeting/meeting_video_widget.dart';
import 'package:flutter_app/src/utils/logger.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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
    return Observer(builder: (_) {
      logger.i("User id : $userId");
      logger.i("Meeting widget : ${meetingStore.statusMap}");
      var status = meetingStore.statusMap[userId] ??
          UserStatusEvent(isMicOn: false, isCameraOn: false);
      return MeetingVideoWidget(
          videoRenderer: p2pMeetingService.remoteVideoRenderer,
          userName: name,
          isMicOn: status.isMicOn,
          isCameraOn: status.isCameraOn);
    });
  }
}
