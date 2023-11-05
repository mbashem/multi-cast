// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:socket_io_client/socket_io_client.dart';

// class RTCManager {
//   RTCPeerConnection? _peerConnection;
//   MediaStream? _localStream;
//   final RTCVideoRenderer _localRenderer = RTCVideoRenderer();

//   final Socket _socket;

//   RTCManager(this._socket);

//   Future<void> initialize() async {
//     await _localRenderer.initialize();
//     await _createPeerConnection();
//     _socket.on('offer', _onOffer);
//     _socket.on('answer', _onAnswer);
//     _socket.on('iceCandidate', _onIceCandidate);
//   }

//   Future<void> _createPeerConnection() async {
//     final configuration = <String, dynamic>{
//       'iceServers': <Map<String, String>>[
//         {'url': 'stun:stun.l.google.com:19302'},
//       ],
//     };

//     _peerConnection =
//         await createPeerConnection(configuration, <String, dynamic>{
//       'mandatory': <String, bool>{
//         'OfferToReceiveVideo': true,
//         'OfferToReceiveAudio': true
//       },
//     });

//     _localStream = await createStream();
//     _localStream.addTrack(await createAudioTrack());
//     _localStream.addTrack(await createVideoTrack());

//     _peerConnection.addStream(_localStream);
//   }

//   void _onOffer(dynamic data) async {
//     // Handle offer from the signaling server
//     final sdp = data['sdp'];
//     final description = RTCSessionDescription(sdp, 'offer');
//     await _peerConnection.setRemoteDescription(description);
//     final answer = await _peerConnection.createAnswer({});
//     await _peerConnection.setLocalDescription(answer);

//     _socket.emit('answer', {'sdp': answer.sdp});
//   }

//   void _onAnswer(dynamic data) {
//     // Handle answer from the signaling server
//     final sdp = data['sdp'];
//     final description = RTCSessionDescription(sdp, 'answer');
//     _peerConnection.setRemoteDescription(description);
//   }

//   void _onIceCandidate(dynamic data) {
//     // Handle ICE candidate from the signaling server
//     final candidate = RTCIceCandidate(
//         data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
//     _peerConnection.addCandidate(candidate);
//   }

//   Future<void> createOffer() async {
//     final offer = await _peerConnection.createOffer({});
//     await _peerConnection.setLocalDescription(offer);

//     _socket.emit('offer', {'sdp': offer.sdp});
//   }

//   Future<void> sendIceCandidate(RTCIceCandidate candidate) {
//     final data = {
//       'candidate': candidate.candidate,
//       'sdpMid': candidate.sdpMid,
//       'sdpMLineIndex': candidate.sdpMlineIndex,
//     };
//     _socket.emit('iceCandidate', data);
//   }

//   Future<void> close() async {
//     _localStream.dispose();
//     _localRenderer.dispose();
//     await _peerConnection.close();
//   }
// }
