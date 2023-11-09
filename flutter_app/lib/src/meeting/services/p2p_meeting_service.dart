import 'dart:convert';

import 'package:flutter_app/src/meeting/models/meeting_event.dart';
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
  final String room;
  final String name;
  String? currSessionId;
  String? remoteSessionId;

  P2PMeetingService(
      {required this.room,
      required this.name,
      this.currSessionId,
      this.remoteSessionId});

  init(io.Socket socket) async {
    this.socket = socket;
    await initRenderers();
    rtcConnection = await _createPeerConnection();
  }

  void initOffer() {
    _createOffer();
  }

  _createMsg(String msg) {
    return MeetingEvent(
        room: room, msg: msg, sender: currSessionId, to: remoteSessionId);
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
          'sdpMid': e.sdpMid,
          'sdpMLineIndex': e.sdpMLineIndex,
        });
        print(candidate);
      }
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

  void addCandidate(MeetingEvent data) async {
    if (!sentCandidate) {
      var session = json.decode(data.msg!);
      logger.i(session);
      String currCandidate = session['candidate'];
      String currSDPMid = session['sdpMid'];
      int currSDPMLineIndex = session['sdpMLineIndex'];
      dynamic candidate =
          RTCIceCandidate(currCandidate, currSDPMid, currSDPMLineIndex);
      await rtcConnection!.addCandidate(candidate);
    }
  }

  void addAnswer(MeetingEvent data) async {
    var signalingState = rtcConnection!.signalingState;
    if (signalingState != RTCSignalingState.RTCSignalingStateHaveRemoteOffer &&
        signalingState !=
            RTCSignalingState.RTCSignalingStateHaveRemotePrAnswer) {
      var sdpParsed = parse(data.msg!);
      String sdp = write(sdpParsed, null);

      RTCSessionDescription description = RTCSessionDescription(sdp, 'answer');

      logger.i("answer: $signalingState");
      await rtcConnection!.setRemoteDescription(description);
      logger.i(sdp);

      socket!.emit("candidate", _createMsg(candidate));
      sentCandidate = true;
    }
  }

  void addOffer(MeetingEvent data) async {
    var signalingState = rtcConnection!.signalingState;
    if (signalingState != RTCSignalingState.RTCSignalingStateHaveLocalOffer &&
        signalingState != RTCSignalingState.RTCSignalingStateHaveRemoteOffer) {
      var sdpParsed = parse(data.msg!);
      // logger.i(data);
      String sdp = write(sdpParsed, null);

      RTCSessionDescription description = RTCSessionDescription(sdp, 'offer');

      // print(description.toMap());
      logger.i("Offer: $signalingState");
      await rtcConnection!.setRemoteDescription(description);
      _createAnswer();
    }
  }

  void _createOffer() async {
    if (currSessionId == null || remoteSessionId == null) {
      return;
    }
    RTCSessionDescription description =
        await rtcConnection!.createOffer({'offerToReceiveVideo': 1});
    // var session = parse(description.sdp!);
    // print(json.encode(session));
    socket!.emit('offer', _createMsg(description.sdp!));

    await rtcConnection!.setLocalDescription(description);
  }

  void _createAnswer() async {
    if (currSessionId == null || remoteSessionId == null) {
      return;
    }
    RTCSessionDescription description =
        await rtcConnection!.createAnswer({'offerToReceiveVideo': 1});
    // var session = parse(description.sdp!);
    socket!.emit("answer", _createMsg(description.sdp!));
    // print(json.encode(session));

    rtcConnection!.setLocalDescription(description);
  }
}
