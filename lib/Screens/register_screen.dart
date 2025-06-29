import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? _selectedMedicalHistory = 'None'; // Default option

  final List<String> medicalHistoryOptions = [
    'None',
    'Anxiety',
    'Social Anxiety',
    'Depression',
    'PTSD',
    'Bipolar Disorder',
    'Prefer not to say',
  ];

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      String email = _usernameController.text;
      String password = _passwordController.text;

      try {
        // Register the user using Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Get the registered user ID
        String userId = userCredential.user!.uid;

        // Now save user data to Firestore under the "Patient" collection
        await FirebaseFirestore.instance.collection('Patient').doc(userId).set({
          'email': email,
          'name': _nameController.text,
          'age': int.parse(_ageController.text),
          'contact': _contactController.text,
          'medicalHistory': _selectedMedicalHistory,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // If the registration is successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful! Please login.')),
        );

        // Navigate back to Login screen
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalMarginInPixels = 5.0 * 37.8; // ~5 cm margins
    final verticalMarginInPixels = 5.0 * 37.8;

    return Scaffold(
      body: Row(
        children: [
          // Left Half with the image and text
          Expanded(
            flex: 1,
            child: Container(
              color: Color(0xFF809694),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.accessibility, size: 100, color: Colors.white),
                    SizedBox(height: 16.0),
                    Text(
                      'Harmonicare',
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2.0),
                    Text(
                      'Healing starts from within',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right Half
          Expanded(
            flex: 1,
            child: Container(

              child: Center(
                child: Container(
                  width: screenWidth / 2 - horizontalMarginInPixels,
                  height: screenHeight - verticalMarginInPixels * 0.8,
                  decoration: BoxDecoration(
                    color: Color(0xFF546260),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Email',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 8.0),
                            CustomTextField(
                              hintText: 'Enter your email',
                              controller: _usernameController,
                              borderColor: Colors.white,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Password',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 8.0),
                            CustomTextField(
                              hintText: 'Enter your password',
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              borderColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Confirm Password',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 8.0),
                            CustomTextField(
                              hintText: 'Confirm your password',
                              controller: _confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible,
                              borderColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Name',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 8.0),
                            CustomTextField(
                              hintText: 'Enter your name',
                              controller: _nameController,
                              borderColor: Colors.white,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Age',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 8.0),
                            CustomTextField(
                              hintText: 'Enter your age',
                              controller: _ageController,
                              borderColor: Colors.white,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your age';
                                }
                                int age = int.tryParse(value) ?? 0;
                                if (age < 1 || age > 100) {
                                  return 'Age must be between 1 and 100';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Contact Information',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 8.0),
                            CustomTextField(
                              hintText: 'Enter your contact number',
                              controller: _contactController,
                              borderColor: Colors.white,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a contact number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Medical History',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 8.0),
                            DropdownButtonFormField<String>(
                              value: _selectedMedicalHistory,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedMedicalHistory = newValue;
                                });
                              },
                              items: medicalHistoryOptions.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                hintText: 'Select your medical history',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty || value == 'None') {
                                  return 'Please select a medical history';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30),
                            CustomButton(
                              text: 'Register',
                              onPressed: _register,
                              textColor: Colors.black,
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginScreen()),
                                  );
                                },
                                child: Text(
                                  'Already have an account? Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final Color borderColor;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  CustomTextField({
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.borderColor = Colors.grey,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
      ),
      validator: validator,
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 514, // Fixed width
        height: 65, // Fixed height
        decoration: BoxDecoration(
          color: Color(0xFF67999A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
