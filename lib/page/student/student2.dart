import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Login_page.dart';
import 'package:my_flutter_app/page/student/studentedit.dart';

class Student2Page extends StatefulWidget {
  @override
  _Student2PageState createState() => _Student2PageState();
}

class _Student2PageState extends State<Student2Page> {
  List<String> items = ['My Profile', 'Log Out'];
  String? dropvalue;

  Future<DocumentSnapshot> getUserData(String userID) async {
    final studentSnapshot = await FirebaseFirestore.instance
        .collection('student')
        .doc(userID)
        .get();

    final adminSnapshot =
        await FirebaseFirestore.instance.collection('Admin').doc(userID).get();

    return adminSnapshot.exists ? adminSnapshot : studentSnapshot;
  }

  Future<QuerySnapshot> getData() async {
    return await FirebaseFirestore.instance.collection('student').get();
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
                      MaterialPageRoute(
                          builder: (context) => Text('My Profile')),
                    );
                  } else if (value == 'Log Out') {
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
          title: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, authSnapshot) {
                if (authSnapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                } else {
                  print(
                      'Authentication state: ${authSnapshot.connectionState}');
                  if (authSnapshot.hasError) {
                    // Print any error that occurred
                    print('Authentication error: ${authSnapshot.error}');
                  }
                  final currentUserID = authSnapshot.data;
                  if (currentUserID == null) {
                    // If user is null, they are not logged in
                    print('User is not logged in');
                  } else if (currentUserID is String) {
                    // If user is a String, it represents the user ID
                    print('User is logged in with UID: $currentUserID');
                  } else {
                    // If user is not null and not a String, it's a User object
                    print('User is logged in: ${currentUserID.uid}');
                  }

                  return FutureBuilder<DocumentSnapshot>(
                    future: currentUserID != null
                        ? getUserData(currentUserID.uid)
                        : null,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Text('Name\nStudent');
                      } else {
                        final userName = snapshot.data!['Name'];

                        return Text(
                          '$userName\nStudent',
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
        body: FutureBuilder<QuerySnapshot>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child:
                        CircularProgressIndicator()); // Show a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('No Data Available'));
              } else {
                List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                return ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      final phoneNo = documents[index]['PhoneNO'];
                      final name = documents[index]['Name'];
                      final AdmissionNo = documents[index]['AdmissionNO'];
                      final roomNo = documents[index]['RoomNo'];
                      final bloodgrp = documents[index]['BloodGroup'];
                      final dept = documents[index]['Department'];
                      final email = documents[index]['Email'];
                      final parentph = documents[index]['GPhoneNo'];
                      final parent = documents[index]['ParentName'];
                      final year = documents[index]['Year'];

                      return Column(
                        children: [
                          SizedBox(
                            height: 70,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Color(0xFFCE5A67),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '$name',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ))),
                          SizedBox(height: 5), // Added space between the texts
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Department ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Color(0xFFCE5A67),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '$dept',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ))),
                          SizedBox(height: 5), // Added space between the texts
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Year ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Color(0xFFCE5A67),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '$year',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ))),
                          SizedBox(height: 5), // Added space between the texts
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Admission No ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Color(0xFFCE5A67),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '$AdmissionNo',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ))),
                          SizedBox(height: 5), // Added space between the texts
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Room No ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Color(0xFFCE5A67),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '$roomNo',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ))),
                          SizedBox(height: 5), // Added space between the texts
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Phone No ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Color(0xFFCE5A67),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '$phoneNo',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ))),
                          SizedBox(height: 5), // Added space between the texts
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Color(0xFFCE5A67),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '$email',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ))),
                          SizedBox(height: 5), // Added space between the texts
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Blood Group ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Color(0xFFCE5A67),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '$bloodgrp',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ))),
                          SizedBox(height: 5), // Added space between the texts
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Parent Name ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Color(0xFFCE5A67),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '$parent',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ))),
                          SizedBox(height: 5), // Added space between the texts
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Phone No ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Color(0xFFCE5A67),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '$parentph',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ))),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentEdit()));
                              },
                              child: Container(
                                  color: Color(0xFFCE5A67),
                                  padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.black),
                                  )))
                        ],
                      );
                    });
              }
            }));
  }
}
