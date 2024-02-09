import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/admin/admin.dart';

class AdminSignup extends StatefulWidget {
  const AdminSignup({super.key});

  @override
  State<AdminSignup> createState() => _AdminSignupState();
}

class _AdminSignupState extends State<AdminSignup> {
  final _emailController = TextEditingController();
  final _PasswordController = TextEditingController();
  final _nameController = TextEditingController();

  String errorMessage = '';

  Future SignUp() async {
    try {
      String email = _emailController.text.trim();
      String password = _PasswordController.text.trim();

      if (email == "dhldhilshana@gmail.com" ||
          email == "sreeyukthap@gmail.com") {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AdminPage()));
      } else {
        print("Unautherized Access");
        setState(() {
          errorMessage = "Sorry, You can't be an admin";
        });
      }
    } catch (e) {
      // Handle sign-up errors here
      print("Error: $e");
      // You can show an error message to the user if sign-up fails
    }

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await saveUserDataToFirestore(
        user,
        _nameController.text.trim(), // using user from userCredential,
        _emailController.text.trim(),
        _PasswordController.text.trim(),
      );
    }
  }

  Future<void> saveUserDataToFirestore(
    User user,
    String Name,
    String Email,
    String Password,
  ) async {
    try {
      String? userID = user.uid;
      await FirebaseFirestore.instance.collection('Admin').doc(userID).set({
        'UserID': userID,
        'Name': Name,
        'Email': Email,
        'Password': Password,
        'FirstRent': 7000,
        'SecondRent': 7000,
        'Mess': true,
        'MessBill': 0,
        'PhoneNO': '',
        'RoomNO': '',
        'StudentName': '',
        'StudentPhoneNO': '',
      });
    } catch (e) {
      print("Error saving user data to Firestore: $e");
      // Handle Firestore data save errors here
    }
  }

  bool passwordVisible = true;

  void dispose() {
    _emailController.dispose();
    _PasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 25,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFFCE5A67),
                    width: 3,
                  ),
                ),
                labelText: "Name",
                labelStyle: const TextStyle(
                  color: Color(0xFFCE5A67),
                ),
              ),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFFCE5A67),
                    width: 3,
                  ),
                ),
                labelText: "Email",
                labelStyle: const TextStyle(
                  color: Color(0xFFCE5A67),
                ),
              ),
            ),
            const SizedBox(height: 30),
            //password
            TextField(
              obscureText: passwordVisible,
              controller: _PasswordController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFFCE5A67),
                    width: 3,
                  ),
                ),
                labelText: "Password",
                labelStyle: const TextStyle(
                  color: Color(0xFFCE5A67),
                ),
              ),
            ),
            const SizedBox(height: 15),

            if (errorMessage
                .isNotEmpty) // Conditionally render the error message
              Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red, // You can adjust the color
                  fontSize: 13,
                ),
              ),

            const SizedBox(height: 15),

            GestureDetector(
              onTap: () {
                SignUp();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                decoration: BoxDecoration(
                  color: Color(0xFFCE5A67),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
