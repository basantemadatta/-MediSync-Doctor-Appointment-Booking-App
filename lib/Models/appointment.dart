// lib/models/appointment.dart
class Appointment {
  final String therapist;
  final String time;
  final String date;
  String status; // 'Reserved', 'Attended', 'Missed'

  Appointment({
    required this.therapist,
    required this.time,
    required this.date,
    this.status = 'Reserved',
  });
}

// In-memory list to store appointments
List<Appointment> appointments = [];
