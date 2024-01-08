// ignore_for_file: unused_import

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
  
 void _handleparent_myprofileContainerClick() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => parent_myprofile()),
  );
}
    void _handleparent_studentContainerClick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => parent_student()),
      
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
            Icons.escalator_warning,
            color: Colors.black,
          ),
          iconSize: 50,
          onPressed: () {
            // Add your onPressed logic here
          },
        ),
        title: Text(
          'Name\nParent',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFCF5ED),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 250,
            ),
             GestureDetector(
                 onTap: _handleparent_myprofileContainerClick,
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
                  'My Profile',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
             SizedBox(
              height: 70,
            ),
            GestureDetector(
               onTap: _handleparent_studentContainerClick,
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
                  'My Student',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                    fontWeight: FontWeight.bold,
                    
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