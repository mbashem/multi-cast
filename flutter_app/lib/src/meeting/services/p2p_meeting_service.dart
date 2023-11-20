import 'dart:convert';

import 'package:flutter_app/src/meeting/models/meeting_event.dart';
import 'package:flutter_app/src/utils/logger.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class P2PMeetingService {
  RTCPeerConnection? rtcConnection;
  bool sentCandidate = false;
  final remoteVideoRenderer = RTCVideoRenderer();
  io.Socket? socket; // shared between P2PMeetingService
  final String room;
  String? currSessionId;
  String? remoteSessionId;
  bool answerEmited = false;
  List<MeetingEvent> candidateQueue = [];

  P2PMeetingService(
      {required this.room, this.currSessionId, this.remoteSessionId});

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

    // await _getUserMedia();

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        var candidate = json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid,
          'sdpMLineIndex': e.sdpMLineIndex,
        });
        socket!.emit("candidate", _createMsg(candidate));
        sentCandidate = true;
        print(candidate);
      }
    };

    pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
      remoteVideoRenderer.srcObject = stream;
    };

    return pc;
  }

  closeConnection() {
    rtcConnection!.close();
    rtcConnection = null;
  }

  removeStream(MediaStream? stream) async {
    if (stream != null) {
      await rtcConnection!.removeStream(stream);
    }
  }

  addStream(MediaStream stream) async {
    await rtcConnection!.addStream(stream);
  }

  initRenderers() async {
    await remoteVideoRenderer.initialize();
  }

  void dispose() {
    remoteVideoRenderer.dispose();
  }

  void toggleMic() async {
    
  }

  void toggleCamera() async {}

  _addCandidateToRTC(MeetingEvent data) async {
    var session = json.decode(data.msg!);
    logger.i(session);
    String currCandidate = session['candidate'];
    String currSDPMid = session['sdpMid'];
    int currSDPMLineIndex = session['sdpMLineIndex'];
    dynamic candidate =
        RTCIceCandidate(currCandidate, currSDPMid, currSDPMLineIndex);
    await rtcConnection!.addCandidate(candidate);
  }

  addCandidate(MeetingEvent data) async {
    if (answerEmited) {
      await _addCandidateToRTC(data);
    } else {
      candidateQueue.add(data);
    }
  }

  applyCandidate() async {
    while (candidateQueue.isNotEmpty) {
      var data = candidateQueue.last;
      await _addCandidateToRTC(data);
      candidateQueue.removeLast();
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
      answerEmited = true;
      await applyCandidate();
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

    await rtcConnection!.setLocalDescription(description);

    answerEmited = true;
    applyCandidate();
  }
}
