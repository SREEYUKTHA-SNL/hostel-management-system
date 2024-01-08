// ignore_for_file: unused_label

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/office/office.dart';
import 'package:my_flutter_app/page/student/student1.dart';
import 'package:my_flutter_app/page/warden/warden2.dart';
import 'package:my_flutter_app/page/warden/wardenattendance.dart';
import 'package:my_flutter_app/page/warden/wardenprofile.dart';
import 'package:my_flutter_app/page/warden/feedetails.dart';
import 'package:my_flutter_app/page/warden/wardenstaff.dart';

class WardenPage extends StatefulWidget {
  @override
  _WardenPageState createState() => _WardenPageState();
  final user = FirebaseAuth.instance.currentUser;
}

class _WardenPageState extends State<WardenPage> {
  List<String> items = ['My Profile', 'Log Out'];
  String? dropvalue;

  ////////////////////////////////////
  void _handlefeedetailsContainerClick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => feedetails()),
    );
  }

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WardenProfile()),
                  );
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
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                //height:100,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFCE5A67),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 50, 48, 48).withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Students',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WardenPage2()));
              },
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                //height:100,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFCE5A67),
                ),
                child: Text(
                  'Attendence',
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
                        builder: (context) => WardenAttendance()));
              },
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                //height:100,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFCE5A67),
                ),
                child: Text(
                  'Fee Details',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => feedetails()));
              },
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                //height:100,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFCE5A67),
                ),
                child: Text(
                  'Mess Details',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => feedetails()));
              },
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Wardenstaff()));
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                //height:100,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFCE5A67),
                ),
                child: Text(
                  'Staff',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
