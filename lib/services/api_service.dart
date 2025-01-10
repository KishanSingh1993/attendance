// File: api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/track_history.dart';

class ApiService {
  static const String baseUrl = 'https://apimis.in/recib/wapi';

  static Future<Map<String, dynamic>?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      body: {'userName': username, 'password': password},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> checkIn(int userId, double latitude, double longitude, String location) async {
    final response = await http.post(
      Uri.parse('$baseUrl/checkIn.php'),
      body: {
        'userId': userId.toString(),
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'location': location,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<List<dynamic>?> fetchAttendanceHistory(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/empAttendanceList.php'),
      body: {'userId': userId.toString()},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['AttendanceList'];
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> checkOut(int userId, int checkInId, double latitude, double longitude, String location, double distance) async {
    final response = await http.post(
      Uri.parse('$baseUrl/checkOut.php'),
      body: {
        'userId': userId.toString(),
        'checkInId': checkInId.toString(),
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'location': location,
        'distance': distance.toString(),
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchAttendanceDetails(int userId, int attendanceId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/trackHistory.php'),
      body: {
        'userId': userId.toString(),
        'attendanceId': attendanceId.toString(),
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<List<AttendanceHistory>?> fetchAttendanceHistoryDetails(
      int userId, int attendanceId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/trackHistory.php'),
      body: {
        'userId': userId.toString(),
        'attendanceId': attendanceId.toString(),
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['attendanceHistory'] != null) {
        return (data['attendanceHistory'] as List)
            .map((item) => AttendanceHistory.fromJson(item))
            .toList();
      }
    }
    return null;
  }


}
