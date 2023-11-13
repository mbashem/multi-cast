import 'package:flutter/material.dart';

class MeetingControlPanel extends StatefulWidget {
  final VoidCallback onToggleAudio;
  final VoidCallback onToggleVideo;
  final VoidCallback onToggleScreenShare;
  final VoidCallback onHangUp;

  const MeetingControlPanel({
    super.key,
    required this.onToggleAudio,
    required this.onToggleVideo,
    required this.onToggleScreenShare,
    required this.onHangUp,
  });

  @override
  State<MeetingControlPanel> createState() => _MeetingControlPanelState();
}

class _MeetingControlPanelState extends State<MeetingControlPanel> {
  bool _isCameraOn = true;
  bool _isMicOn = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.black54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon((_isMicOn ? Icons.mic : Icons.mic_off)),
            onPressed: () {
              widget.onToggleAudio();
              setState(() {
                _isMicOn = !_isMicOn;
              });
            },
            color: Colors.white,
          ),
          IconButton(
            icon: Icon((_isCameraOn ? Icons.videocam : Icons.videocam_off)),
            onPressed: () {
              widget.onToggleVideo();
              setState(() {
                _isCameraOn = !_isCameraOn;
              });
            },
            color: Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.screen_share),
            onPressed: widget.onToggleScreenShare,
            color: Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.call_end),
            onPressed: widget.onHangUp,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
