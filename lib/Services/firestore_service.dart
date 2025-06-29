import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// FirestoreService for interacting with Firestore collections
class FirestoreService {
  final CollectionReference patients = FirebaseFirestore.instance.collection('Patient');
  final CollectionReference therapists = FirebaseFirestore.instance.collection('Therapist');
  final CollectionReference appointments = FirebaseFirestore.instance.collection('Appointments');

  // 🔥 Add Patient
  Future<void> addPatient(
      String name,
      String email,
      int age,
      String contact,
      String medicalHistory,
      ) async {
    await patients.add({
      'name': name,
      'email': email,
      'age': age,
      'contact': contact,
      'medicalHistory': medicalHistory,
    });
  }

  // 🔥 Add Therapist
  Future<void> addTherapist(String name, String speciality, String bio, List<String> timing) async {
    await therapists.add({
      'name': name,
      'speciality': speciality,
      'bio': bio,
      'timing': timing, // This is an array of available timings
    });
  }


  // 🔥 Add Appointment
  Future<void> addAppointments(String patientID, String therapistID, String date, String time) async {
    await appointments.add({
      'patientID': patientID,
      'therapistID': therapistID,
      'date': date,
      'time': time,
    });
  }
}
