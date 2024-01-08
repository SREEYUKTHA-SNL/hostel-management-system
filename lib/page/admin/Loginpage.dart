import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/warden/warden.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controller
  final _emailController = TextEditingController();
  final _PasswordController = TextEditingController();
  String selectedUserType = '';
  bool isLoginSectionVisible = false;

  Future LOGIN() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _PasswordController.text.trim(),
      );
    } catch (e) {
      // Handle and display the login error
      print("Login Error: $e");
      // Show an error message to the user
      // You can use a SnackBar or AlertDialog to display the error message
    }
  }

  String getHeaderText() {
    switch (selectedUserType) {
      case 'warden':
        return 'Hello warden, please fill out this to get started!';
      case 'parent':
        return 'Hello parent, please fill out this to get started!';
      case 'staff':
        return 'Hello staff, please fill out this to get started!';
      case 'student':
        return 'Hello student, please fill out this to get started!';
      default:
        return 'Hello, please select your Account type!';
    }
  }

  // Function to handle the container click
  void _handleContainerClick(String userType) {
    setState(() {
      selectedUserType = userType;
      isLoginSectionVisible = true;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _PasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFCF5ED),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                const Text(
                  'Choose account type',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _handleContainerClick('warden');
                        isLoginSectionVisible = true; // Update user type here
                      },
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCE5A67),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                size: 80.0,
                                color: Colors.black,
                              ),
                              Text(
                                'WARDEN',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ////////////////////////////
                    GestureDetector(
                      onTap: () {
                        _handleContainerClick(
                            'student'); // Update user type here
                        isLoginSectionVisible = true;
                      },
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCE5A67),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_circle,
                                size: 80.0,
                                color: Colors.black,
                              ),
                              Text(
                                'STUDENT',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ////////////////////////////////////////////////////////////////
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ///////////////////////////////////
                    GestureDetector(
                      onTap: () {
                        _handleContainerClick('parent');
                        isLoginSectionVisible = true; // Update user type here
                      },
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCE5A67),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.escalator_warning,
                                size: 80.0,
                                color: Colors.black,
                              ),
                              Text(
                                'PARENT',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ////////////////////////////////
                    GestureDetector(
                      onTap: () {
                        _handleContainerClick('staff'); // Update user type here
                        isLoginSectionVisible = true;
                      },
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCE5A67),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.group,
                                size: 80.0,
                                color: Colors.black,
                              ),
                              Text(
                                'STAFF',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    /////////////////////////////////////////
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  getHeaderText(),
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: isLoginSectionVisible,
                  child: Column(
                    children: [
                      //userid
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
                        controller: _PasswordController,
                        decoration: InputDecoration(
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
                      const SizedBox(height: 30),

                      //LOGIN
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30, 7, 30, 7),
                          decoration: BoxDecoration(
                            color: Color(0xFFCE5A67),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                            onPressed: () {
                              LOGIN();
                            },
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
