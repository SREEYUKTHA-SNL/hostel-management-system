// ignore_for_file: unused_import, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/page/warden/register_parent.dart';
import 'package:my_flutter_app/page/warden/wardenstudent.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _Name = TextEditingController();
  final _Department = TextEditingController();
  final _PhoneNo = TextEditingController();
  final _AdmissionNo = TextEditingController();
  final _BloodGroup = TextEditingController();
  final _ParentName = TextEditingController();
  final _GPhoneNo = TextEditingController();
  final _RoomNo = TextEditingController();
  final _Year = TextEditingController();
  final _emailController = TextEditingController();
  final _PasswordController = TextEditingController();
  final _GraduationController = TextEditingController();

  String? _selectedGraduation;
  String? _selectedYear;
  final _formKey = GlobalKey<FormState>();
  late String _currentUserId;
  late String studentUserId;

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

  Future<void> registerUserWithEmailAndPassword() async {
    try {
      String email =
          _PhoneNo.text.trim() + '@gmail.com'; // Using phone number as email
      String password =
          _AdmissionNo.text.trim(); // Using admission number as password

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? studentUser = FirebaseAuth.instance.currentUser;

      if (studentUser != null) {
        await saveUserDataToFirestore(
          studentUser, // using user from userCredential,
          _Name.text.trim(),
          _Department.text.trim(),
          _PhoneNo.text.trim(),
          _AdmissionNo.text.trim(),
          _BloodGroup.text.trim(),
          _ParentName.text.trim(),
          _GPhoneNo.text.trim(),
          _RoomNo.text.trim(),
          _Year.text.trim(),
          _GraduationController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Student registered successfully!'),
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
    String Department,
    String PhoneNo,
    String AdmissionNo,
    String BloodGroup,
    String ParentName,
    String GPhoneNo,
    String RoomNo,
    String Year,
    String Graduation,
  ) async {
    try {
      setState(() {
        studentUserId = user.uid;
      });
       
      await FirebaseFirestore.instance.collection('student').doc(studentUserId).set({
        'UserID': studentUserId,
        'Name': Name,
        'Department': Department,
        'PhoneNO': PhoneNo,
        'AdmissionNO': AdmissionNo,
        'BloodGroup': BloodGroup,
        'ParentName': ParentName,
        'GPhoneNo': GPhoneNo,
        'RoomNo': RoomNo,
        'Year': Year,
        'Graduation': Graduation,
        'Attendance': false,
        'FirstRent': 7000,
        'SecondRent': 7000,
        'Mess': false,
        'MessBill': 0,
        'Position': 'Student',
        'Email': PhoneNo + '@gmail.com', // Store phone number as email
        'Password': AdmissionNo, // Store admission number as password
        'FirstRentPay': false,
        'SecondRentPay': false,
      });
    } catch (e) {
      print("Error saving user data to Firestore: $e");
      // Handle Firestore data save errors here
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

  void dispose() {
    _Name.dispose();
    _AdmissionNo.dispose();
    _BloodGroup.dispose();
    _Department.dispose();
    _GPhoneNo.dispose();
    _ParentName.dispose();
    _PhoneNo.dispose();
    _RoomNo.dispose();
    _Year.dispose();
    _GraduationController.dispose();
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
                DropdownButtonFormField<String>(
                  value: _selectedGraduation,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This Field is required';
                    }
                    return null; // Return null if the validation passes
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFCE5A67),
                        width: 3,
                      ),
                    ),
                    labelText: "UG/PG/B-ED\*",
                    labelStyle: TextStyle(
                      color: Color(0xFFCE5A67),
                    ),
                  ),
                  items: ['UG', 'PG', 'B.ED'].map((String graduation) {
                    return DropdownMenuItem<String>(
                      value: graduation,
                      child: Text(graduation),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGraduation = newValue;
                      _GraduationController.text = newValue!;
                    });
                  },
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
                  controller: _Department,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFCE5A67),
                        width: 3,
                      ),
                    ),
                    labelText: "Department\*",
                    labelStyle: TextStyle(
                      color: Color(0xFFCE5A67),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                  value: _selectedYear,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This Field is required';
                    }
                    return null; // Return null if the validation passes
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFCE5A67),
                        width: 3,
                      ),
                    ),
                    labelText: "Year\*",
                    labelStyle: TextStyle(
                      color: Color(0xFFCE5A67),
                    ),
                  ),
                  items: ['First', 'Second', 'Third'].map((String yearr) {
                    return DropdownMenuItem<String>(
                      value: yearr,
                      child: Text(yearr),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedYear = newValue;
                      _Year.text = newValue!;
                    });
                  },
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
                TextFormField(
                  keyboardType:
                      TextInputType.text, // Set to accept only numeric input

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This Field is required';
                    }
                    return null; // Return null if the validation passes
                  },
                  controller: _AdmissionNo,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFCE5A67),
                        width: 3,
                      ),
                    ),
                    labelText: "Admission No\*",
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
                  controller: _BloodGroup,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFCE5A67),
                        width: 3,
                      ),
                    ),
                    labelText: "Blood Group\*",
                    labelStyle: TextStyle(
                      color: Color(0xFFCE5A67),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType:
                      TextInputType.number, // Set to accept only numeric input
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
                  controller: _RoomNo,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFCE5A67),
                        width: 3,
                      ),
                    ),
                    labelText: "Room No\*",
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
                  controller: _ParentName,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFCE5A67),
                        width: 3,
                      ),
                    ),
                    labelText: "Parent Name\*",
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
                  controller: _GPhoneNo,
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
                TextButton(
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.black, // Set the text color
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await registerUserWithEmailAndPassword();
                      await FirebaseAuth.instance.signOut();
                      await SignInWarden();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => register_parent(
                                  selectedDegree:
                                      _GraduationController.text.trim(),
                                  selectedYear: _Year.text.trim(),
                                  name: _ParentName.text.trim(),
                                  phoneNo: _GPhoneNo.text.trim(),
                                  studName: _Name.text.trim(),
                                  studPhone: _PhoneNo.text.trim(),
                                  room: _RoomNo.text.trim(),
                                  userID:studentUserId,
                                )),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
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
