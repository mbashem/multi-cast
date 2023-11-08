import 'package:flutter_app/src/utils/logger.dart';
import 'package:flutter_app/src/utils/urls.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class MeetingApiService {
  io.Socket socket = io.io(socketURL, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  MeetingApiService() {
    socket.connect();
    socket.onConnect((data) => logger.i('connected'));
  }
}
