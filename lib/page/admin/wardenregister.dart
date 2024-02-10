import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WardenRegister extends StatefulWidget {
  const WardenRegister({super.key});

  @override
  State<WardenRegister> createState() => _WardenRegisterState();
}

class _WardenRegisterState extends State<WardenRegister> {
  final _Name = TextEditingController();
  final _PhoneNo = TextEditingController();
  final _Email = TextEditingController();
  final _Password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<UserCredential?> registerUserWithEmailAndPassword(
    String email, // Using phone number as email
    String password, // Using admission number as password
  ) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print("Error registering user: $e");
      return null; // Return null if registration fails
    }
  }

  Future<void> saveUserDataToFirestore(
    UserCredential userCredential,
    String Name,
    String PhoneNo,
  ) async {
    try {
      String? userID = userCredential.user?.uid;
      await FirebaseFirestore.instance.collection('Warden').doc(userID).set({
        'UserID': userID,
        'Name': Name,
        'PhoneNO': PhoneNo,
        'Email': Name, // Store phone number as email
        'Password': PhoneNo, // Store admission number as password
      });
    } catch (e) {
      print("Error saving user data to Firestore: $e");
      // Handle Firestore data save errors here
    }
  }

  Future SignUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _Email.text.trim(),
        password: _Password.text.trim(),
      );
    } catch (e) {
      // Handle sign-up errors here
      print("Error: $e");
      // You can show an error message to the user if sign-up fails
    }
  }

  void dispose() {
    _Name.dispose();
    _PhoneNo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Color(0xFFF4BF96),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(40),
            ),
          ),
          title: Text(
            'Register',
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          centerTitle: true,
          elevation: 18,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  keyboardType:
                      TextInputType.text, // Set to accept only numeric input

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This Field is required';
                    }
                    return null; // Return null if the validation passes
                  },
                  controller: _Name,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFCE5A67),
                        width: 3,
                      ),
                    ),
                    labelText: "Name\*",
                    labelStyle: TextStyle(
                      color: Color(0xFFCE5A67),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType:
                      TextInputType.phone, // Set to accept only numeric input
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Allows only digits
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This Field is required';
                    }
                    return null; // Return null if the validation passes
                  },
                  controller: _PhoneNo,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFCE5A67),
                        width: 3,
                      ),
                    ),
                    labelText: "Phone No\*",
                    labelStyle: TextStyle(
                      color: Color(0xFFCE5A67),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.black, // Set the text color
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String email = _Name.text.trim() +
                          '@gmail.com'; // Phone number as email
                      String password =
                          _PhoneNo.text.trim(); // Admission number as password

                      UserCredential? userCredential =
                          await registerUserWithEmailAndPassword(
                              email, password);

                      if (userCredential != null) {
                        await saveUserDataToFirestore(
                          userCredential,
                          _Name.text.trim(),
                          _PhoneNo.text.trim(),
                        );

                        // Navigate to the appropriate page after successful registration
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFFCE5A67),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      // Set the border radius for the button
                    ),
                    elevation: 18, // Set the elevation for the button
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
