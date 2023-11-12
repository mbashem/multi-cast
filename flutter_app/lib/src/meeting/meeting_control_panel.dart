import 'package:flutter/material.dart';

class MeetingControlPanel extends StatelessWidget {
  final VoidCallback onToggleAudio;
  final VoidCallback onToggleVideo;
  final VoidCallback onToggleScreenShare;
  final VoidCallback onHangUp;

  const MeetingControlPanel({super.key, 
    required this.onToggleAudio,
    required this.onToggleVideo,
    required this.onToggleScreenShare,
    required this.onHangUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.black54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: onToggleAudio,
            color: Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: onToggleVideo,
            color: Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.screen_share),
            onPressed: onToggleScreenShare,
            color: Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.call_end),
            onPressed: onHangUp,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
