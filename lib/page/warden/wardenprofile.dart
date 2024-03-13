import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Login_page.dart';
import 'package:my_flutter_app/page/warden/warden2.dart';
import 'package:my_flutter_app/page/warden/wardenedit.dart';

class WardenProfile extends StatefulWidget {
  const WardenProfile({super.key});

  @override
  State<WardenProfile> createState() => _WardenProfileState();
}

class _WardenProfileState extends State<WardenProfile> {
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
                position: RelativeRect.fromLTRB(0, 100, 100, 0),
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
          child: FutureBuilder(
              future: FirebaseAuth.instance.authStateChanges().first,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show a loading indicator while fetching data
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Text('No Data Available');
                } else {
                  final currentUserID = snapshot.data!.uid;
                  return FutureBuilder<DocumentSnapshot>(
                      future: getUserData(currentUserID),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Center(
                              child: Text(
                                  'No data available for the current user'));
                        } else {
                          final phoneNo = snapshot.data!['PhoneNO'];
                          final name = snapshot.data!['Name'];
                          final email = snapshot.data!['Email'];

                          return ListView(children: [
                            SizedBox(
                              height: 30,
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
                            SizedBox(height: 5),
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
                            SizedBox(height: 5),
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
                                      '$email@gmail.com',
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
                            SizedBox(height: 5),
                            Center(
                                child: Column(children: [
                              Container(
                                width: 220,
                                padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                                child: ElevatedButton(
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WardenEdit()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Color(0xFFCE5A67),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: 20), // Add some space between buttons
                              Container(
                                width: 220,
                                padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                                child: ElevatedButton(
                                  child: Text(
                                    "Log Out",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () {
                                    FirebaseAuth.instance
                                        .signOut()
                                        .then((value) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login_Page()),
                                        (Route<dynamic> route) => false,
                                      );
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Color(0xFFCE5A67),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ]))
                          ]);
                        }
                      });
                }
              }),
        ));
  }
}
