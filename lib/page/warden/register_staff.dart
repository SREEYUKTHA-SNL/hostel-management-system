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
  late String _currentUserId;
  late String staffUserId;

  void initState() {
    super.initState();
    // Get the current user's UID when the page is initialized
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        setState(() {
          _currentUserId = currentUser.uid;
        });
        print('current user $_currentUserId');
      } else {
        print("No user is currently authenticated.");
      }
    } catch (e) {
      print("Error getting current user's UID: $e");
    }
  }

  Future<UserCredential?> registerUserWithEmailAndPassword() async {
    try {
      String email = _name.text.trim().replaceAll(" ", '') + '@gmail.com';
      String password = _phoneNo.text.trim();
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? staffUser = FirebaseAuth.instance.currentUser;

      if (staffUser != null) {
        await saveUserDataToFirestore(
            staffUser, // using user from userCredential,
            _name.text.trim(),
            _phoneNo.text.trim());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Staff registered successfully!'),
                duration: Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {},
                )),
          );
        }
      }
    } catch (e) {
      print("Error registering user: $e");
      return null; // Return null if registration fails
    }
  }

  Future<void> saveUserDataToFirestore(
    User user,
    String Name,
    String PhoneNo,
  ) async {
    try {
      setState(() {
        staffUserId = user.uid;
      });

      await FirebaseFirestore.instance
          .collection('staffdetails')
          .doc(staffUserId)
          .set({
        'UserID': staffUserId,
        'Name': Name,
        'PhoneNO': PhoneNo,
        'Email': Name.replaceAll(" ", "") + '@gmail.com',
        'Password': PhoneNo,
        'Attendance': false,
      });
    } catch (e) {
      print("Error saving user data to Firestore: $e");
    }
  }

  Future SignInWarden() async {
    DocumentSnapshot wardenSnapshot = await FirebaseFirestore.instance
        .collection('Warden')
        .doc(_currentUserId)
        .get();
    String email = wardenSnapshot.get('Email');
    String password = wardenSnapshot.get('Password');
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email + '@gmail.com',
      password: password,
    );
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
                      registerUserWithEmailAndPassword();
                      FirebaseAuth.instance.signOut();
                      await SignInWarden();
                    }
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Wardenstaff()));
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
