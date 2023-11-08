import 'dart:convert';

import 'package:flutter_app/src/utils/logger.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class P2PMeetingService {
  RTCPeerConnection? rtcConnection;
  MediaStream? localMediaStream;
  dynamic candidate;
  bool sentCandidate = false;
  final localVideoRenderer = RTCVideoRenderer();
  final remoteVideoRenderer = RTCVideoRenderer();
  io.Socket? socket; // shared between P2PMeetingService

  // P2PMeetingService(this.socket);

  void init(io.Socket socket) {
    this.socket = socket;
    initRenderers();
    _createPeerConnection().then((pc) {
      rtcConnection = pc;
    });
    connectToSocketServer();
  }

  void initOffer() {
    _createOffer();
  }

  void connectToSocketServer() {
    socket!.connect();
    logger.i("Socket connecting");
    socket!.onConnect((data) {
      socket!.emit("joinRoom", "42");
    });
    socket!.on('offer', (data) async {
      var signalingState = rtcConnection!.signalingState;
      if (signalingState != RTCSignalingState.RTCSignalingStateHaveLocalOffer &&
          signalingState !=
              RTCSignalingState.RTCSignalingStateHaveRemoteOffer) {
        data = json.decode(data);
        // logger.i(data);
        String sdp = write(data, null);

        RTCSessionDescription description = RTCSessionDescription(sdp, 'offer');

        // print(description.toMap());
        logger.i("Offer: $signalingState");
        await rtcConnection!.setRemoteDescription(description);
        _createAnswer();
      }
    });
    socket!.on('answer', (data) async {
      var signalingState = rtcConnection!.signalingState;
      if (signalingState !=
              RTCSignalingState.RTCSignalingStateHaveRemoteOffer &&
          signalingState !=
              RTCSignalingState.RTCSignalingStateHaveRemotePrAnswer) {
        data = json.decode(data);
        String sdp = write(data, null);

        RTCSessionDescription description =
            RTCSessionDescription(sdp, 'answer');

        logger.i("answer: $signalingState");
        await rtcConnection!.setRemoteDescription(description);
        logger.i(sdp);

        socket!.emit(candidate);
        sentCandidate = true;
      }
    });
    socket!.on('candidate', (session) async {
      if (!sentCandidate) {
        logger.i(session);
        dynamic candidate = RTCIceCandidate(
            session['candidate'], session['sdpMid'], session['sdpMLineIndex']);
        await rtcConnection!.addCandidate(candidate);
      }
    });
    socket!.on('chat_message', (data) {
      logger.i(data);
    });
  }

  _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      'iceServers': [
        {'url': 'stun:stun.l.google.com:19302'},
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': true,
      },
      'optional': [],
    };

    localMediaStream = await _getUserMedia();

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);
    pc.addStream(localMediaStream!);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        candidate = json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMLineIndex': e.sdpMLineIndex,
        });
        print(candidate);
      }
    };

    pc.onIceConnectionState = (e) {
      // print(e);
    };

    pc.onAddStream = (stream) {
      // print('addStream: ' + stream.id);
      remoteVideoRenderer.srcObject = stream;
    };

    return pc;
  }

  initRenderers() async {
    await localVideoRenderer.initialize();
    await remoteVideoRenderer.initialize();
  }

  void dispose() {
    localVideoRenderer.dispose();
    remoteVideoRenderer.dispose();
    socket!.dispose();
  }

  _getUserMedia() async {
    final Map<String, dynamic> constraints = {
      'audio': false,
      'video': {
        'facingMode': 'user',
      }
    };

    try {
      MediaStream stream =
          await navigator.mediaDevices.getUserMedia(constraints);
      localVideoRenderer.srcObject = stream;
      return stream;
    } catch (e) {
      // Handle the error or absence of user media.
      print("Failed to get user media: $e");
      // You can display a message to the user or take appropriate action.
      // For example, show an error message or provide alternative options.
      return null;
    }
  }

  void _createOffer() async {
    RTCSessionDescription description =
        await rtcConnection!.createOffer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp!);
    // print(json.encode(session));
    socket!.emit('offer', {'room': "42", 'sdp': json.encode(session)});

    await rtcConnection!.setLocalDescription(description);
  }

  void _createAnswer() async {
    RTCSessionDescription description =
        await rtcConnection!.createAnswer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp!);
    socket!.emit("answer", {'room': "42", 'sdp': json.encode(session)});
    // print(json.encode(session));

    rtcConnection!.setLocalDescription(description);
  }
}
