import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/page/admin/admin.dart';

class OfficeRegister extends StatefulWidget {
  const OfficeRegister({super.key});

  @override
  State<OfficeRegister> createState() => _OfficeRegisterState();
}

class _OfficeRegisterState extends State<OfficeRegister> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  Future SignInAdmin() async {
    DocumentSnapshot adminSnapshot =
        await FirebaseFirestore.instance.collection('Admin').doc('').get();
    String email = adminSnapshot.get('Email');
    String password = adminSnapshot.get('Password');
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email + '@gmail.com',
      password: password,
    );
  }

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
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await saveUserDataToFirestore(
            userCredential, // using user from userCredential,
            _email.text.trim(),
            _password.text.trim());
        if (context != null && mounted) {
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
    UserCredential userCredential,
    String Email,
    String Password,
  ) async {
    try {
      String? userID = userCredential.user?.uid;
      await FirebaseFirestore.instance.collection('Office').doc(userID).set({
        'UserID': userID,
        'Email': Email,
        'Password': Password,
      });
    } catch (e) {
      print("Error saving user data to Firestore: $e");
    }
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
                  controller: _email,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFCE5A67),
                        width: 3,
                      ),
                    ),
                    labelText: "Email*",
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
                  controller: _password,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFFCE5A67),
                        width: 3,
                      ),
                    ),
                    labelText: "Password*",
                    labelStyle: TextStyle(
                      color: Color(0xFFCE5A67),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String email = _email.text.trim();
                      String password = _password.text.trim();

                      UserCredential? userCredential =
                          await registerUserWithEmailAndPassword(
                              email, password);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Student registered successfully!'),
                            duration: Duration(seconds: 3),
                            action:
                                SnackBarAction(label: 'OK', onPressed: () {})),
                      );
                      // await FirebaseAuth.instance.signOut();
                      // await SignInAdmin();
                    }
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AdminPage()));
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
