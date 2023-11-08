import 'dart:convert';

import 'package:flutter_app/src/meeting/models/meeting.dart';
import 'package:flutter_app/src/utils/urls.dart';
import 'package:http/http.dart' as http;


Future<Meeting?> startMeeting() async {
  var requestHeaders = {'Content-Type': 'application/json'};

  var response = await http.get(Uri.parse("$apiURL/start-meeting"),
      headers: requestHeaders);

  if (response.statusCode == 200) {
    try {
      // Parse the response body as JSON
      Map<String, dynamic> responseData = json.decode(response.body);

      // Extract the "meetingId" field
      String meetingId = responseData['meetingId'];
      String hostId = responseData["hostId"];

      return Meeting(id: meetingId, hostId: hostId);
    } catch (e) {
      // Handle any JSON parsing errors
      return null;
    }
  } else {
    return null;
  }
}
