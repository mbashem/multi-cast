import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoOverlay extends StatelessWidget {
  final RTCVideoRenderer videoRenderer;
  final String userName;
  final bool isMicMuted;
  final bool isCameraMuted;
  final bool mirror;

  const VideoOverlay({super.key, 
    required this.videoRenderer,
    required this.userName,
    required this.isMicMuted,
    required this.isCameraMuted,
    this.mirror = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Video view
        Container(
          key: Key(userName),
          margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          decoration: const BoxDecoration(color: Colors.black),
          child: RTCVideoView(
            videoRenderer,
            mirror: mirror,
          ),
        ),

        // Overlay elements
        Positioned(
          top: 8.0,
          left: 8.0,
          child: Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          bottom: 8.0,
          left: 8.0,
          child: Row(
            children: [
              Icon(
                isMicMuted ? Icons.mic_off : Icons.mic,
                color: Colors.white,
              ),
              const SizedBox(width: 8.0),
              Icon(
                isCameraMuted ? Icons.videocam_off : Icons.videocam,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
