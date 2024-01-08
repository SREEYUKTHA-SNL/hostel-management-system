// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_flutter_app/page/warden/wardenprofile.dart';
import 'package:my_flutter_app/page/warden/wardenstudent.dart';

class WardenPage2 extends StatefulWidget {
  @override
  _WardenPage2State createState() => _WardenPage2State();
}

Future<String> fetchData() async {
  final QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('student').get();
  final int documents = snapshot.docs.length;
  return documents.toString();
}

Future<String> attendance() async {
  final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('student')
      .where('Attendance', isEqualTo: 'in')
      .get();
  final int attended = snapshot.docs.length; // Fix variable name
  return attended.toString();
}

Future<DocumentSnapshot> getUserData(String userID) async {
  return await FirebaseFirestore.instance
      .collection('Warden')
      .doc(userID)
      .get();
}

class _WardenPage2State extends State<WardenPage2> {
  List<String> items = ['My Profile', 'Log Out'];
  String? dropvalue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF4BF96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.account_circle,
            color: Colors.black,
          ),
          iconSize: 50,
          onPressed: () {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                  0, 100, 100, 0), // Adjust position as needed
              items: items.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ).then((value) {
              setState(() {
                dropvalue = value;
                if (value == 'My Profile') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WardenProfile()));
                } else if (value == 'Log Out')
                  (FirebaseAuth.instance.signOut());
              });
            });
          },
        ),
        title: FutureBuilder<User?>(
            future: FirebaseAuth.instance.authStateChanges().first,
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              } else {
                final currentUserID = userSnapshot.data!.uid;

                return FutureBuilder<DocumentSnapshot>(
                  future: getUserData(currentUserID),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Text('Name\nWarden');
                    } else {
                      final userName = snapshot.data!['Name'];

                      return Text(
                        '$userName\nWarden',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    }
                  },
                );
              }
            }),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 130,
                  width: 130,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFCE5A67),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Students',
                        style: TextStyle(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 15, 14, 14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FutureBuilder<String>(
                        future: fetchData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text(
                              snapshot.data!,
                              style: TextStyle(
                                fontSize: 25,
                                color: const Color.fromARGB(255, 15, 14, 14),
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                Container(
                    height: 130,
                    width: 130,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFCE5A67),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Students\nchecked in',
                          style: TextStyle(
                            fontSize: 20,
                            color: const Color.fromARGB(255, 15, 14, 14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FutureBuilder<String>(
                            future: attendance(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Text(
                                  snapshot.data!,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color:
                                        const Color.fromARGB(255, 15, 14, 14),
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            })
                      ],
                    )),
              ],
            ),
            SizedBox(height: 30.0),
            Column(
              children: [
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFCE5A67),
                    ),
                    child: Text(
                      'UG',
                      style: TextStyle(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 15, 14, 14),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WardenStudent(
                                selectedDegree: 'UG',
                                selectedYear: 'First',
                              )),
                    );
                  },
                ),
                SizedBox(height: 30.0),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFCE5A67),
                    ),
                    child: Text(
                      'PG',
                      style: TextStyle(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 15, 14, 14),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WardenStudent(
                                selectedDegree: 'PG',
                                selectedYear: 'First',
                              )),
                    );
                  },
                ),
                SizedBox(height: 30.0),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFCE5A67),
                    ),
                    child: Text(
                      'B.ED',
                      style: TextStyle(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 15, 14, 14),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WardenStudent(
                                selectedDegree: 'B.ED',
                                selectedYear: 'First',
                              )),
                    );
                  },
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
