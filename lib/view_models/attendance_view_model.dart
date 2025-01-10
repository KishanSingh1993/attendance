// File: attendance_view_model.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AttendanceViewModel extends ChangeNotifier {
  List<dynamic>? attendanceHistory;
  bool isLoading = false;

  Future<void> fetchAttendanceHistory(int userId) async {
    isLoading = true;
    notifyListeners();

    attendanceHistory = await ApiService.fetchAttendanceHistory(userId);

    isLoading = false;
    notifyListeners();
  }
}
