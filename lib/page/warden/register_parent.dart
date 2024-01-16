import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/page/warden/wardenstudent.dart';

class register_parent extends StatefulWidget {
  final String name;
  final String phoneNo;
  final String studName;
  final String studPhone;
  final String room;
  final String selectedDegree;
  final String selectedYear;

  const register_parent(
      {Key? key,
      required this.selectedDegree,
      required this.selectedYear,
      required this.name,
      required this.phoneNo,
      required this.studName,
      required this.studPhone,
      required this.room})
      : super(key: key);
  @override
  State<register_parent> createState() => __register_parentStateState();
}

class __register_parentStateState extends State<register_parent> {
  final _formKey = GlobalKey<FormState>();

  final _Name = TextEditingController();
  final _PhoneNo = TextEditingController();
  final _StudentName = TextEditingController();
  final _StudentPhoneNO = TextEditingController();
  final _RoomNo = TextEditingController();

  Future SignInWarden() async {
    DocumentSnapshot wardenSnapshot = await FirebaseFirestore.instance
        .collection('Warden')
        .doc('Y19H4JCbyleWxjVMqem3a1RQ8Qz1')
        .get();
    String email = wardenSnapshot.get('Email');
    String password = wardenSnapshot.get('Password');
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email + '@gmail.com',
      password: password,
    );
  }

  Future<void> registerUserWithEmailAndPassword() async {
    try {
      String email = _Name.text.trim().replaceAll(' ', '') +
          '@gmail.com'; // Using name as email
      String password = _PhoneNo.text.trim(); // Using Phone number as password

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await Register(
          user, // using user from userCredential,
          _Name.text.trim(),
          _PhoneNo.text.trim(),
          _StudentName.text.trim(),
          _StudentPhoneNO.text.trim(),

          _RoomNo.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Parent registered successfully!'),
              duration: Duration(seconds: 3),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              )),
        );
      }
    } catch (e) {
      print("Error registering user: $e");
      return null; // Return null if registration fails
    }
  }

  Future<void> Register(
    User user,
    String Name,
    String PhoneNO,
    String StudentName,
    String StudentPhoneNO,
    String RoomNo,
  ) async {
    String? userID = user.uid;
    await FirebaseFirestore.instance.collection('parent').doc(userID).set({
      'UserId': userID,
      'Name': Name,
      'PhoneNO': PhoneNO,
      'StudentName': StudentName,
      'StudentPhoneNO': StudentPhoneNO,
      'RoomNO': RoomNo,
      'Email': Name + '@gmail.com',
      'Password': PhoneNO,
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

  void initState() {
    super.initState();
    _Name.text = widget.name;
    _PhoneNo.text = widget.phoneNo;
    _StudentName.text = widget.studName;
    _StudentPhoneNO.text = widget.studPhone;
    _RoomNo.text = widget.room;
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
                      labelText: "Name",
                      labelStyle: TextStyle(
                        color: Color(0xFFCE5A67),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter
                          .digitsOnly, // Allows only digits
                    ], // Set to accept only numeric input

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
                      labelText: "Phone NO",
                      labelStyle: TextStyle(
                        color: Color(0xFFCE5A67),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType:
                        TextInputType.text, // Set to accept only numeric input

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This Field is required';
                      }
                      return null; // Return null if the validation passes
                    },
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
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ], // Set to accept only numeric input

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This Field is required';
                      }
                      return null; // Return null if the validation passes
                    },
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
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Set to accept only numeric input

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This Field is required';
                      }
                      return null; // Return null if the validation passes
                    },

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
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await registerUserWithEmailAndPassword();
                         await FirebaseAuth.instance.signOut();
                         await SignInWarden();
                      }

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WardenStudent(
                            selectedDegree: widget.selectedDegree,
                            selectedYear: widget.selectedYear,
                          ),
                        ),
                      );
                      
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFFCE5A67),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 18, // Set the elevation for the button
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
