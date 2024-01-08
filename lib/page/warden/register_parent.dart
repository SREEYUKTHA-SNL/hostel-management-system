import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class register_parent extends StatefulWidget {
  const register_parent({Key? key}) : super(key: key);

  @override
  State<register_parent> createState() => __register_parentStateState();
}

class __register_parentStateState extends State<register_parent> {
  final _Name = TextEditingController();
  final _PhoneNo = TextEditingController();
  final _StudentName = TextEditingController();
  final _StudentPhoneNO = TextEditingController();
  final _RoomNo = TextEditingController();

  final _emailController = TextEditingController();
  final _PasswordController = TextEditingController();

   Future Register(
      String Name,
      String PhoneNO,
      String StudentName,
      String StudentPhoneNO,
      String RoomNo,
     ) async {
    await FirebaseFirestore.instance
        .collection('parent')
        
        .add({
      'Name': Name,
      'PhoneNO': PhoneNO,
      'StudentName': StudentName,
      'StudentPhoneNO': StudentPhoneNO,
      'RoomNO': RoomNo,
    });
  }

  void dispose() {
    _Name.dispose();
    _PhoneNo.dispose();
    _StudentName.dispose();
    _StudentPhoneNO.dispose();
    _RoomNo.dispose();
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
              bottom: Radius.circular(
                  40), // Set the border radius for the bottom left corner
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: _Name,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFCE5A67),
                        width: 3,
                      ),
                    ),
                    labelText: "Name",
                    labelStyle: TextStyle(
                      color: Color(0xFFCE5A67),
                    ),
                  ),
                ),
                 SizedBox(height: 20),
              TextField(
                controller: _PhoneNo,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFFCE5A67),
                      width: 3,
                    ),
                  ),
                  labelText: "Phone NO",
                  labelStyle: TextStyle(
                    color: Color(0xFFCE5A67),
                  ),
                ),
              ),
               SizedBox(height: 20),
              TextField(
                controller: _StudentName,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFFCE5A67),
                      width: 3,
                    ),
                  ),
                  labelText: "Student Name",
                  labelStyle: TextStyle(
                    color: Color(0xFFCE5A67),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _StudentPhoneNO,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFFCE5A67),
                      width: 3,
                    ),
                  ),
                  labelText: "Student Phone NO",
                  labelStyle: TextStyle(
                    color: Color(0xFFCE5A67),
                  ),
                  
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _RoomNo,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFFCE5A67),
                      width: 3,
                    ),
                  ),
                  labelText: "Room NO",
                  labelStyle: TextStyle(
                    color: Color(0xFFCE5A67),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add your logic for button press here
                  // For example, you can validate the form fields and submit the registration data
                  // Replace the print statement with your actual logic.
                  print("Registration button pressed");
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
                child: TextButton(
                    onPressed: () {
                      Register(
                        _Name.text.trim(),
                        _PhoneNo.text.trim(),
                        _StudentName.text.trim(),
                        _StudentPhoneNO.text.trim(),
                        _RoomNo.text.trim(),
                        
                      );
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.black, // Set the text color
                      ),
                    )),
              ),
              ]),
        ),
      ),
    );
  }
}
