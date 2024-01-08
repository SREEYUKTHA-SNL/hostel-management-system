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
      String? userID = userCredential.user?.uid;
      await FirebaseFirestore.instance.collection('student').doc(userID).set({
        'UserID': userID,
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
        'Fee': false,
        'MessFee': false,
        'Position': 'Student',
        'Email': PhoneNo, // Store phone number as email
        'Password': AdmissionNo, // Store admission number as password
        'Rent': false
      });
    } catch (e) {
      print("Error saving user data to Firestore: $e");
      // Handle Firestore data save errors here
    }
  }

  Future SignUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _PasswordController.text.trim(),
      );
    } catch (e) {
      // Handle sign-up errors here
      print("Error: $e");
      // You can show an error message to the user if sign-up fails
    }
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
                      String email = _PhoneNo.text.trim() +
                          '@gmail.com'; // Phone number as email
                      String password = _AdmissionNo.text
                          .trim(); // Admission number as password

                      UserCredential? userCredential =
                          await registerUserWithEmailAndPassword(
                              email, password);

                      if (userCredential != null) {
                        await saveUserDataToFirestore(
                          userCredential,
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
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WardenStudent(
                            selectedDegree: _GraduationController.text.trim(),
                            selectedYear: _Year.text.trim(),
                          ),
                        ),
                      );
                      // String selectedGraduation =
                      //     _GraduationController.text.trim();
                      // if (selectedGraduation == 'UG') {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => WardenStudent(
                      //         selectedDegree: 'UG',
                      //         selectedYear: _Year.text.trim(),
                      //       ),
                      //     ),
                      //   );
                      // } else if (selectedGraduation == 'PG') {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => WardenStudent(
                      //         selectedDegree: 'PG',
                      //         selectedYear: _Year.text.trim(),
                      //       ),
                      //     ),
                      //   );
                      // } else {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => WardenStudent(
                      //         selectedDegree: 'B.ED',
                      //         selectedYear: _Year.text.trim(),
                      //       ),
                      //     ),
                      //   );
                      // }
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
