import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication

class BookAppointmentPage extends StatefulWidget {
  final String therapistId; // Instead of passing the full therapist data, we pass the ID

  BookAppointmentPage({required this.therapistId});

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  late DateTime selectedDate;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now(); // Default to current date
  }

  // Fetch therapist data from Firestore
  Future<DocumentSnapshot> _fetchTherapistData() async {
    return await FirebaseFirestore.instance
        .collection('Therapist')
        .doc(widget.therapistId) // Fetch using therapistId
        .get();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Save the appointment
  void _bookAppointment() async {
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a time slot!')),
      );
      return;
    }

    // Get the logged-in user's email
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User is not logged in. Please log in first.')),
      );
      return;
    }
    final String patientEmail = user.email!;

    // Create the appointment (replace with actual Firestore save if needed)
    final appointmentData = {
      'therapistId': widget.therapistId,
      'therapistName': selectedTime!,
      'time': selectedTime!,
      'date': "${selectedDate.toLocal()}".split(' ')[0],
      'patientEmail': patientEmail, // Add patient email
    };

    try {
      // Save the appointment in Firestore (or in your own model)
      await FirebaseFirestore.instance.collection('Appointments').add(appointmentData);

      // Navigate back with success message
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked successfully!')),
      );
    } catch (e) {
      print("Error booking appointment: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _fetchTherapistData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Book Appointment')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Book Appointment')),
            body: Center(child: Text('Something went wrong!')),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(title: Text('Book Appointment')),
            body: Center(child: Text('Therapist not found.')),
          );
        }

        final therapist = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(title: Text('Book Appointment with ${therapist['name']}')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Date:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Choose Date'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Available Timings:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: therapist['timing'].length,
                    itemBuilder: (context, index) {
                      final time = therapist['timing'][index];
                      return RadioListTile<String>(
                        title: Text(time),
                        value: time,
                        groupValue: selectedTime,
                        onChanged: (value) {
                          setState(() {
                            selectedTime = value;
                          });
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _bookAppointment,
                  child: Text('Confirm Appointment'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}