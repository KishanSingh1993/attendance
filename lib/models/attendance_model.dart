// File: attendance_model.dart
class Attendance {
  final int attendanceCode;
  final String checkIn;
  final String? checkOut;
  final String duration;
  final String distance;

  Attendance({
    required this.attendanceCode,
    required this.checkIn,
    this.checkOut,
    required this.duration,
    required this.distance,
  });
}