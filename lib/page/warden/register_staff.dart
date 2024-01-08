// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/page/warden/wardenstaff.dart';

class register_staff extends StatefulWidget {
  const register_staff({super.key});

  @override
  State<register_staff> createState() => _register_staffState();
}

class _register_staffState extends State<register_staff> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phoneNo = TextEditingController();
  final _Email = TextEditingController();
  final _Password = TextEditingController();

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
      await FirebaseFirestore.instance
          .collection('staffdetails')
          .doc(userID)
          .set({
        'UserID': userID,
        'Name': Name,
        'PhoneNO': PhoneNo,
        'Email': Name,
        'Password': PhoneNo,
        'Attendance': false,
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

  @override
  void dispose() {
    _name.dispose();
    _phoneNo.dispose();

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
              color: Colors.black,
            ),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This Field is required';
                    }
                    return null;
                  },
                  controller: _name,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFCE5A67),
                        width: 3,
                      ),
                    ),
                    labelText: "Name*",
                    labelStyle: TextStyle(
                      color: Color(0xFFCE5A67),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This Field is required';
                    }
                    return null;
                  },
                  controller: _phoneNo,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFCE5A67),
                        width: 3,
                      ),
                    ),
                    labelText: "Phone No*",
                    labelStyle: TextStyle(
                      color: Color(0xFFCE5A67),
                    ),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String email = _name.text.trim() + '@gmail.com';
                      String password = _phoneNo.text.trim();

                      UserCredential? userCredential =
                          await registerUserWithEmailAndPassword(
                              email, password);

                      if (userCredential != null) {
                        await saveUserDataToFirestore(
                          userCredential,
                          _name.text.trim(),
                          _phoneNo.text.trim(),
                        );

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Wardenstaff()));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFFCE5A67),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 18,
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.black,
                    ),
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
