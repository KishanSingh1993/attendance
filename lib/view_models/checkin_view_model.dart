import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';

class CheckInViewModel extends ChangeNotifier {
  bool isLoading = false;
  bool isCheckedIn = false; // To track the current check-in status
  int? checkInId; // To store the ID of the current check-in
  String checkInTime = ''; // To store the current check-in time

  /// Sets the loading state and notifies listeners.
  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  /// Updates the check-in status, ID, and time, then notifies listeners.
  void setCheckedIn(bool checkedIn, {int? id, String? checkInTime}) {
    isCheckedIn = checkedIn;
    checkInId = id;
    if (checkInTime != null) {
      this.checkInTime = checkInTime;
    }
    notifyListeners();
  }

  /// Handles the check-in process.
  Future<Map<String, dynamic>?> handleCheckIn(int userId) async {
    try {
      final position = await LocationService.getCurrentLocation();
      final response = await ApiService.checkIn(
        userId,
        position.latitude,
        position.longitude,
        "Current Location",
      );
      return response;
    } catch (e) {
      debugPrint("Error during check-in: $e");
      return null;
    }
  }

  /// Handles the check-out process.
  Future<Map<String, dynamic>?> handleCheckOut(int userId, double distance) async {
    if (checkInId == null) {
      debugPrint("No active check-in to check out from.");
      return null;
    }

    try {
      final position = await LocationService.getCurrentLocation();
      final response = await ApiService.checkOut(
        userId,
        checkInId!,
        position.latitude,
        position.longitude,
        "Current Location",
        distance,
      );
      return response;
    } catch (e) {
      debugPrint("Error during check-out: $e");
      return null;
    }
  }
}
