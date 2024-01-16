import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/admin/admin.dart';
import 'package:my_flutter_app/page/parent/parent.dart';
import 'package:my_flutter_app/page/staff/staff2.dart';
import 'package:my_flutter_app/page/student/student1.dart';
import 'page/warden/warden.dart';
import 'page/Loginpage.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({super.key});

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<DocumentSnapshot>(
                future: _firestore
                    .collection('Warden')
                    .doc(snapshot.data!.uid)
                    .get(), // Adjust collection name here
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child:
                            CircularProgressIndicator()); // Show a loading indicator while fetching data
                  }

                  if (userSnapshot.hasError) {
                    return Center(
                        child: Text(
                            'Error: ${userSnapshot.error}')); // Display an error if encountered
                  }

                  if (userSnapshot.hasData && userSnapshot.data!.exists) {
                    // Check if the document exists
                    return WardenPage(); // Show warden page
                  } else {
                    // If the document doesn't exist in the 'warden' collection, check 'student' collection
                    return FutureBuilder<DocumentSnapshot>(
                      future: _firestore
                          .collection('student')
                          .doc(snapshot.data!.uid)
                          .get(),
                      builder: (context, studentSnapshot) {
                        if (studentSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (studentSnapshot.hasError) {
                          return Center(
                              child: Text('Error: ${studentSnapshot.error}'));
                        }

                        if (studentSnapshot.hasData &&
                            studentSnapshot.data!.exists) {
                          return Student1Page(); // Show student page if document exists in 'student' collection
                        } else {
                          return FutureBuilder<DocumentSnapshot>(
                            future: _firestore
                                .collection('staffdetails')
                                .doc(snapshot.data!.uid)
                                .get(),
                            builder: (context, staffSnapshot) {
                              if (staffSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (staffSnapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Error: ${staffSnapshot.error}',
                                  ),
                                );
                              }

                              if (staffSnapshot.hasData &&
                                  staffSnapshot.data!.exists) {
                                return StaffPage2(); // Show staff page
                              } else {
                                return FutureBuilder<DocumentSnapshot>(
                                  future: _firestore
                                      .collection('parent')
                                      .doc(snapshot.data!.uid)
                                      .get(),
                                  builder: (context, parentSnapshot) {
                                    if (parentSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (parentSnapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          'Error: ${parentSnapshot.error}',
                                        ),
                                      );
                                    }

                                    if (parentSnapshot.hasData &&
                                        parentSnapshot.data!.exists) {
                                      return parent(); // Show parent page
                                    }
                             else {
                                      return FutureBuilder<DocumentSnapshot>(
                          future: _firestore
                              .collection('parent')
                              .doc(snapshot.data!.uid)
                              .get(),
                          builder: (context, parentSnapshot) {
                            if (parentSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (parentSnapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Error: ${parentSnapshot.error}',
                                ),
                              );
                            }

                            if (parentSnapshot.hasData &&
                                parentSnapshot.data!.exists) {
                              return parent(); // Show staff page
                            }
                             else {
                              return AdminPage(); // Default to login page if not found in all collections
                                    }
                          },
                        );// Default to login page if not found in all collections
                            }
                                  },
                                );
                              }
                            },
                          );
                        }
                      },
                    );
                  }
                });
          } else {
            return LoginPage(); // Default to login page if not found in both collections
          }
        },
      ),
    );
  }
}
