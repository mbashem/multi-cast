import 'package:flutter_app/src/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<http.Response?> startMeeting() async {
  var requestHeaders = {'Content-Type': 'application/json'};

  var response = await http.get(Uri.parse("$apiURL/start-meeting"),
      headers: requestHeaders);

  if (response.statusCode == 200) {
    return response;
  } else {
    return null;
  }
}
