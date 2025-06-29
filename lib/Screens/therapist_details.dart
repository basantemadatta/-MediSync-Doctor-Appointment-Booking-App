import 'package:flutter/material.dart';
import '../models/appointment.dart';

class TherapistDetails extends StatefulWidget {
  final Map<String, dynamic> therapist;

  TherapistDetails({required this.therapist});

  @override
  _TherapistDetailsState createState() => _TherapistDetailsState();
}

class _TherapistDetailsState extends State<TherapistDetails> {
  Map<String, bool> selectedTiming = {};

  @override
  void initState() {
    super.initState();
    for (var time in widget.therapist['timing']) {
      selectedTiming[time] = false;
    }
  }

  void _confirmAppointments() {
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

    for (String time in selectedTimes) {
      appointments.add(Appointment(
        therapist: widget.therapist['name'],
        time: time,
        date: 'Dec 1, 2024', // Replace with dynamic date logic
      ));
    }

    setState(() {
      widget.therapist['timing'].removeWhere((time) => selectedTimes.contains(time));
      selectedTiming.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Appointments confirmed for: ${selectedTimes.join(", ")} with ${widget.therapist['name']}',
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.therapist['name']),
        backgroundColor: Color(0xFF809694),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Therapist Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.therapist['name'],
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Specialty: ${widget.therapist['speciality']}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Biography:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.therapist['bio'],
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Available Timing Section
              Text(
                'Available Timings:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  child: Column(
                    children: selectedTiming.keys.map((time) {
                      return CheckboxListTile(
                        title: Text(time),
                        value: selectedTiming[time],
                        onChanged: (bool? value) {
                          setState(() {
                            selectedTiming[time] = value ?? false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Confirm Appointment Button
              ElevatedButton(
                onPressed: _confirmAppointments,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Color(0xFF809694),
                ),
                child: Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
