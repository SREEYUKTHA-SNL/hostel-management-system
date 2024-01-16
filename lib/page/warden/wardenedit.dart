// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/warden/warden2.dart';
import 'package:my_flutter_app/page/warden/wardenprofile.dart';

class WardenEdit extends StatefulWidget {
  const WardenEdit({super.key});

  @override
  State<WardenEdit> createState() => _WardenEditState();
}

class _WardenEditState extends State<WardenEdit> {
  final _emailController = TextEditingController();
  final _phoneNo = TextEditingController();

  Future ResetEmail(
    String newEmail,
  ) async {
    await FirebaseFirestore.instance
        .collection('Warden')
        .doc('Y19H4JCbyleWxjVMqem3a1RQ8Qz1')
        .update({'Email': newEmail});
  }

  Future ResetPhoneNo(
    String newPhoneNo,
  ) async {
    await FirebaseFirestore.instance
        .collection('Warden')
        .doc('Y19H4JCbyleWxjVMqem3a1RQ8Qz1')
        .update({'PhoneNo': newPhoneNo});
  }

  Future<DocumentSnapshot> getData() async {
    return await FirebaseFirestore.instance
        .collection('Warden')
        .doc('Y19H4JCbyleWxjVMqem3a1RQ8Qz1')
        .get();
  }

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WardenProfile()),
                    );
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
        body: FutureBuilder<DocumentSnapshot>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Text('No Data Available');
              } else {
                final email = snapshot.data!['Email'];
                final phoneNo = snapshot.data!['PhoneNO'];

                final documentId = snapshot.data!.id;

                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                          // color: Color(0xFFCE5A67),
                          child: Text(
                            'Phone Number\n$phoneNo',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.3,
                              color: const Color.fromARGB(255, 15, 14, 14),
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    title: Text('Change your Phone Number'),
                                    content: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Phone No',
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide(
                                            color: Color(0xFFCE5A67),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontSize: 15,
                                            height: 1.3,
                                            color: Color(0xFFCE5A67),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            fontSize: 15,
                                            height: 1.3,
                                            color: Color(0xFFCE5A67),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        onPressed: () {
                                          ResetPhoneNo(_phoneNo.text.trim());
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text(
                              'Change your Phone Number',
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.3,
                                color: Color.fromARGB(255, 27, 177, 232),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                    ]);
              }
            }));
  }
}
