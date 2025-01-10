import 'package:flutter/material.dart';

import '../models/track_history.dart';
import '../services/api_service.dart';

class AttendanceHistoryViewModel extends ChangeNotifier {
  List<AttendanceHistory> _attendanceHistory = [];
  bool _isLoading = false;

  List<AttendanceHistory> get attendanceHistory => _attendanceHistory;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> fetchHistory(int userId, int attendanceId) async {
    setLoading(true);
    try {
      final history = await ApiService.fetchAttendanceHistoryDetails(
          userId, attendanceId);
      if (history != null) {
        _attendanceHistory = history;
      }
    } catch (e) {
      debugPrint("Error fetching attendance history: $e");
    } finally {
      setLoading(false);
    }
  }
}
