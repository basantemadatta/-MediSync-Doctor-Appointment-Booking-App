import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'therapist_details.dart';

class TherapistList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Therapists'),
        backgroundColor: Color(0xFF809694), // Updated color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Therapist').snapshots(),
        builder: (context, snapshot) {
          // 🔄 Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // ❌ Error handling
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong. Please try again later.',
                style: TextStyle(color: Colors.red), // Highlighting error text
              ),
            );
          }

          // 📭 No data found
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No therapists available at the moment.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            );
          }

          // 📋 Get therapist list
          final therapists = snapshot.data!.docs;

          return ListView.builder(
            itemCount: therapists.length, // No limit, display all therapists
            itemBuilder: (context, index) {
              // 🟢 Extract therapist data safely
              final therapistData = therapists[index].data() as Map<String, dynamic>?;

              if (therapistData == null) {
                return Center(
                  child: Text(
                    'Data not available.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              // 🟢 Extract therapist fields safely
              String therapistName = therapistData['name'] ?? 'Unknown Name';
              String therapistSpeciality =
                  therapistData['speciality'] ?? 'Speciality not specified';

              return Card(
                color: Color(0xFFEFEFEF), // Slightly lighter background for cards
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.person, color: Color(0xFF809694)), // Updated color
                  title: Text(
                    therapistName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF606060),
                    ),
                  ),
                  subtitle: Text(
                    'Speciality: $therapistSpeciality',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TherapistDetails(therapist: therapistData),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
