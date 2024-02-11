import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Login_page.dart';
import 'package:my_flutter_app/page/admin/officeregister.dart';
import 'package:my_flutter_app/page/admin/wardenregister.dart';
import 'package:my_flutter_app/page/office/office.dart';
import 'package:my_flutter_app/page/parent/parent.dart';
import 'package:my_flutter_app/page/parent/parent_myprofile.dart';
import 'package:my_flutter_app/page/staff/staff2.dart';
import 'package:my_flutter_app/page/student/student1.dart';
import 'package:my_flutter_app/page/warden/warden.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
  //final user = FirebaseAuth.instance.currentUser;
}

class _AdminPageState extends State<AdminPage> {
  List<String> items = ['Log Out'];
  String? dropvalue;

  Future<DocumentSnapshot> getUserData(String userID) async {
    return await FirebaseFirestore.instance
        .collection('Admin')
        .doc(userID)
        .get();
  }

  bool showAddIcon = false;
  bool addwarden = false;

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
                if (value == 'Log Out') {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Login_Page()),
                      (Route<dynamic> route) => false,
                    );
                  });
                }
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
                        '$userName\nAdmin',
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WardenPage()),
                );
              },
              onLongPress: () {
                setState(() {
                  addwarden = !addwarden;
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFCE5A67),
                ),
                child: addwarden
                    ? IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WardenRegister()));
                        },
                        icon: Icon(Icons.add))
                    : Text(
                        'Warden',
                        style: TextStyle(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 15, 14, 14),
                        ),
                      ),
              ),
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Student1Page()),
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
                  'Student',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StaffPage2()),
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
                  'Staff',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => parent()),
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
                  'Parent',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => office()));
              },
              onLongPress: () {
                setState(() {
                  showAddIcon = !showAddIcon;
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFCE5A67),
                ),
                child: showAddIcon
                    ? IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OfficeRegister()));
                        },
                        icon: Icon(Icons.add))
                    : Text(
                        'Office',
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
