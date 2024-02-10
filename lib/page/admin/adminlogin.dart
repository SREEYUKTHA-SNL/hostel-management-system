import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/admin/admin.dart';
import 'package:my_flutter_app/page/admin/adminsignup.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _emailController = TextEditingController();
  final _PasswordController = TextEditingController();

  String errorMessage = '';
  bool passwordVisible = true;

  Future<void> Login() async {
    String email = _emailController.text.trim();
    String password = _PasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please enter both email and password.';
      });
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AdminPage()));
    } catch (e) {
      // Handle and display the login error
      print("Login Error: $e");
      if (e is FirebaseAuthException && e.code == 'ERROR_INVALID_CREDENTIAL') {
        setState(() {
          errorMessage = 'Invalid user. Please sign up.';
        });
      } else {
        setState(() {
          errorMessage = 'An error occurred. Please try again later.';
        });
      }
    }
  }

  void dispose() {
    _emailController.dispose();
    _PasswordController.dispose();
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
            SizedBox(height: 30),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account ? Please ",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AdminSignup()));
                  },
                  child: Text(
                    "Sign Up.",
                    style: TextStyle(
                        color: Color(0xFFCE5A67),
                        fontSize: 13,
                        fontWeight: FontWeight.w900),
                  ),
                )
              ],
            ),

            if (errorMessage
                .isNotEmpty) // Conditionally render the error message
              Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red, // You can adjust the color
                  fontSize: 13,
                ),
              ),

            SizedBox(height: 15),

            GestureDetector(
              onTap: () {
                Login();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                decoration: BoxDecoration(
                  color: Color(0xFFCE5A67),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Login',
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
