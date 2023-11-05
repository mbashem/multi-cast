import 'dart:convert';

import 'package:flutter_app/src/meeting/models/meeting.dart';
import 'package:http/http.dart' as http;

class MeetingApiService {
  final String baseUrl;
  final http.Client httpClient;

  MeetingApiService({required this.baseUrl, required this.httpClient});

  Future<Meeting> createMeeting(String name) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/meetings'),
      body: jsonEncode({'name': name}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Meeting(id: data['id'], name: data['name']);
    } else {
      throw Exception('Failed to create a meeting');
    }
  }

  Future<Meeting> joinMeeting(String meetingId) async {
    final response =
        await httpClient.get(Uri.parse('$baseUrl/meetings/$meetingId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Meeting(id: data['id'], name: data['name']);
    } else {
      throw Exception('Meeting not found');
    }
  }
}
