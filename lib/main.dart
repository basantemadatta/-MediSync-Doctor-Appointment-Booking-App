import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
 await Firebase.initializeApp(
   options:const FirebaseOptions(
     apiKey: "AIzaSyBCuXXxKOylEMUCPYgCEGkHCoqv2OmDyQQ",
     authDomain: "therapist-project.firebaseapp.com",
     projectId: "therapist-project",
     storageBucket: "therapist-project.firebasestorage.app",
     messagingSenderId: "629114959681",
     appId: "1:629114959681:web:884ec0900f41b7527b53c0",
     measurementId: "G-VLLB9EG5MG"
   )); } // Initialize Firebase
  else {
   await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Therapy Clinic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),  // Replace with your initial screen
    );
  }
}
