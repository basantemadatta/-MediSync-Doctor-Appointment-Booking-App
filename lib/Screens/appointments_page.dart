import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<Map<String, dynamic>> therapists = []; // Will store therapist data from Firestore
  String? selectedTherapist;
  Map<String, bool> selectedTiming = {};

  // Fetch therapist data from Firestore
  Future<void> _fetchTherapists() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('Therapist').get();
      final List<Map<String, dynamic>> therapistList = [];

      for (var doc in snapshot.docs) {
        therapistList.add(doc.data() as Map<String, dynamic>);
      }

      setState(() {
        therapists = therapistList; // Update the therapists list with data from Firestore
      });
    } catch (e) {
      print("Error fetching therapists: $e");
    }
  }

  void _confirmAppointments() {
    if (selectedTherapist == null) return;

    List<String> selectedTimes = selectedTiming.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one time slot!')),
      );
      return;
    }

    // Save selected appointments to history (no changes to therapist timing here)
    for (String time in selectedTimes) {
      appointments.add(Appointment(
        therapist: selectedTherapist!,
        time: time,
        date: 'Dec 1, 2024', // Replace with dynamic date logic
      ));
    }

    // Clear the selections
    setState(() {
      selectedTherapist = null;
      selectedTiming.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Appointments confirmed for: ${selectedTimes.join(", ")} with $selectedTherapist.'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchTherapists(); // Fetch therapists data when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointments'),
        backgroundColor: Color(0xFF809694), // Set the app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Therapist selection dropdown with custom styling
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Color(0xFF809694).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 3)),
                ],
              ),
              child: DropdownButton<String>(
                value: selectedTherapist,
                hint: Text('Select a Therapist'),
                isExpanded: true,
                onChanged: (String? value) {
                  setState(() {
                    selectedTherapist = value;
                    selectedTiming = {}; // Reset selected timing
                    // Initialize the timing map for the selected therapist
                    final therapist = therapists.firstWhere((t) => t['name'] == value);
                    for (var time in therapist['timing']) {
                      selectedTiming[time] = false;
                    }
                  });
                },
                items: therapists.map<DropdownMenuItem<String>>((therapist) {
                  return DropdownMenuItem<String>(
                    value: therapist['name'],
                    child: Text(therapist['name']),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            if (selectedTherapist != null) ...[
              // Therapist specialty section with padding and background
              Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Color(0xFF809694).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Specialty: ${therapists.firstWhere((t) => t['name'] == selectedTherapist)['speciality']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF809694),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Available timings header
              Text(
                'Available Timings:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF809694)),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: selectedTiming.keys.map((time) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 3)),
                        ],
                      ),
                      child: CheckboxListTile(
                        title: Text(time),
                        value: selectedTiming[time],
                        onChanged: (bool? value) {
                          setState(() {
                            selectedTiming[time] = value ?? false;
                          });
                        },
                        activeColor: Color(0xFF809694), // Set checkbox active color
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              // Confirm appointment button with styling
              ElevatedButton(
                onPressed: _confirmAppointments,
                child: Text('Confirm Appointments'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), backgroundColor: Color(0xFF809694), // Set button color
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ] else
              Expanded(
                child: Center(
                  child: Text(
                    'Please select a therapist to view available timings.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
