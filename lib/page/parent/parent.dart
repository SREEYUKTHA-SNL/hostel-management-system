// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/parent/parent_myprofile.dart';
import 'package:my_flutter_app/page/parent/parent_student.dart';

class parent extends StatefulWidget {
  @override
  State<parent> createState() => _parentState();
  final user = FirebaseAuth.instance.currentUser;
}

class _parentState extends State<parent> {
  List<String> items = ['My Profile', 'Log Out'];
  String? dropvalue;

  Future<DocumentSnapshot> getUserData(String userID) async {
    final parentSnapshot =
        await FirebaseFirestore.instance.collection('parent').doc(userID).get();

    final adminSnapshot =
        await FirebaseFirestore.instance.collection('Admin').doc(userID).get();

    return adminSnapshot.exists ? adminSnapshot : parentSnapshot;
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
            Icons.escalator_warning,
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
                      MaterialPageRoute(
                          builder: (context) => parent_myprofile()));
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
              } else if (userSnapshot.hasError) {
                return Text('Error: ${userSnapshot.error}');
              } else if (!userSnapshot.hasData || userSnapshot.data == null) {
                return Text('Name\nStaff');
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
                      return Text('Name\nStaff');
                    } else {
                      final userName = snapshot.data!['Name'];

                      return Text(
                        '$userName\nParent',
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
      backgroundColor: const Color(0xFFFCF5ED),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => parent_myprofile()),
                );
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFCE5A67),
                ),
                child: Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => parent_student()),
                );
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
                  'My Student',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
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
