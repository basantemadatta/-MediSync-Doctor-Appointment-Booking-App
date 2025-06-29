class Therapist {
  final String name;
  final String specialty;
  final String bio;
  final List<String> timings;

  Therapist({
    required this.name,
    required this.specialty,
    required this.bio,
    required this.timings,
  });

  // Convert a Firestore document to a Therapist instance
  factory Therapist.fromMap(Map<String, dynamic> map) {
    return Therapist(
      name: map['name'],
      specialty: map['specialty'],
      bio: map['bio'],
      timings: List<String>.from(map['timings'] ?? []),
    );
  }

  // Convert a Therapist instance to a Firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'bio': bio,
      'timings': timings,
    };
  }
}
