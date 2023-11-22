import 'package:flutter_app/src/auth/auth_service.dart';
import 'package:flutter_app/src/utils/urls.dart';
import 'dart:convert';

import 'package:flutter_app/src/meeting/models/meeting.dart';
import 'package:http/http.dart' as http;

class MeetingApiService {
  static Future<Meeting?> createMeeting() async {
    try {
      var token = await AuthService.getJWTToken();
      var requestHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
        // "Access-Control-Allow-Origin": "*"
      };

      var response = await http.get(Uri.parse("$apiURL/create-meeting"),
          headers: requestHeaders);

      if (response.statusCode == 200) {
        // Parse the response body as JSON
        Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the "meetingId" field
        String meetingId = responseData['meetingId'];
        int hostId = responseData["hostId"];

        return Meeting(id: meetingId, hostId: hostId);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      // Handle any JSON parsing errors
      return null;
    }
  }
}
