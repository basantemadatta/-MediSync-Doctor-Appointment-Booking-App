// lib/services/therapist_service.dart
class TherapistService {
  static final List<Map<String, dynamic>> therapists = [
    {
      'name': 'Dr. Smith',
      'specialty': 'Cognitive Therapy',
      'timings': ['9:00 AM', '11:00 AM', '3:00 PM']
    },
    {
      'name': 'Dr. Jane',
      'specialty': 'Behavioral Therapy',
      'timings': ['10:00 AM', '2:00 PM', '4:00 PM']
    },
    {
      'name': 'Dr. Lee',
      'specialty': 'Family Counseling',
      'timings': ['8:00 AM', '12:00 PM', '5:00 PM']
    },
  ];

  // Update available timings for a therapist
  static void addTiming(String therapistName, String timing) {
    final therapist =
    therapists.firstWhere((t) => t['name'] == therapistName);
    if (!therapist['timings'].contains(timing)) {
      therapist['timings'].add(timing);
      therapist['timings'].sort(); // Optional: Keep times sorted
    }
  }

  static void removeTiming(String therapistName, String timing) {
    final therapist =
    therapists.firstWhere((t) => t['name'] == therapistName);
    therapist['timings'].remove(timing);
  }

  static List<Map<String, dynamic>> getAllTherapists() => therapists;
}
