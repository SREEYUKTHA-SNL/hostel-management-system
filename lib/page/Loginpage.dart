import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/admin/adminlogin.dart';

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
      case 'office':
        return 'Hello office, please fill out this to get started!';
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

  bool passwordVisible = true;

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
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCE5A67),
                          borderRadius: BorderRadius.circular(15.0),
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
                                'Warden',
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
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCE5A67),
                          borderRadius: BorderRadius.circular(15.0),
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
                                'Student',
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
                    GestureDetector(
                      onTap: () {
                        _handleContainerClick('parent');
                        isLoginSectionVisible = true; // Update user type here
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCE5A67),
                          borderRadius: BorderRadius.circular(15.0),
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
                                'Parent',
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
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _handleContainerClick('staff'); // Update user type here
                        isLoginSectionVisible = true;
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCE5A67),
                          borderRadius: BorderRadius.circular(15.0),
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
                                'Staff',
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
                    GestureDetector(
                      onTap: () {
                        _handleContainerClick('office');
                        isLoginSectionVisible = true; // Update user type here
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCE5A67),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.apartment,
                                size: 80.0,
                                color: Colors.black,
                              ),
                              Text(
                                'Office',
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminLogin()));
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCE5A67),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.admin_panel_settings,
                                size: 80.0,
                                color: Colors.black,
                              ),
                              Text(
                                'Admin',
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
                      const SizedBox(height: 30),

                      //LOGIN
                      GestureDetector(
                        onTap: () {
                          LOGIN();
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
