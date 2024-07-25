import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Login_page.dart';
import 'package:my_flutter_app/page/student/student2.dart';

class StudentEdit extends StatefulWidget {
  const StudentEdit({super.key});

  @override
  State<StudentEdit> createState() => _StudentEditState();
}

class _StudentEditState extends State<StudentEdit> {
  List<String> items = ['My Profile', 'Log Out'];
  String? dropvalue;
  final _phoneNo = TextEditingController();
  final _roomNo = TextEditingController();
  final _year = TextEditingController();
  bool showInfoText = false;

  Future<DocumentSnapshot> getUserData(String userID) async {
    final parentSnapshot = await FirebaseFirestore.instance
        .collection('student')
        .doc(userID)
        .get();

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
                      MaterialPageRoute(builder: (context) => Student2Page()),
                    );
                  } else if (value == "Log Out") {
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
                print('Authentication state: ${authSnapshot.connectionState}');
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
                      return Text('Name\nParent');
                    } else {
                      final userName = snapshot.data![
                          'Name']; // Replace 'Name' with your actual field name

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
            },
          ),
        ),
        body: FutureBuilder<User?>(
            future: FirebaseAuth.instance.authStateChanges().first,
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child:
                        CircularProgressIndicator()); // Show a loading indicator while fetching data
              } else if (userSnapshot.hasError) {
                return Center(child: Text('Error: ${userSnapshot.error}'));
              } else if (!userSnapshot.hasData || userSnapshot.data == null) {
                return Center(child: Text('No Data Available'));
              } else {
                final currentUserID = userSnapshot.data!.uid;

                return FutureBuilder<DocumentSnapshot>(
                    future: getUserData(currentUserID),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Center(
                            child:
                                Text('No data available for the current user'));
                      } else {
                        final phoneNo = snapshot.data!['PhoneNO'];
                        final roomNo = snapshot.data!['RoomNo'];
                        final year = snapshot.data!['Year'];
                        final email = snapshot.data!['Email'];

                        return ListView(children: [
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                              child: Text(
                                'Phone Number\n$phoneNo',
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.3,
                                  color: const Color.fromARGB(255, 15, 14, 14),
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          // GestureDetector(
                          //     onTap: () {
                          //       showDialog(
                          //           context: context,
                          //           builder: (BuildContext context) {
                          //             return AlertDialog(
                          //               shape: RoundedRectangleBorder(
                          //                 borderRadius: BorderRadius.all(
                          //                     Radius.circular(20.0)),
                          //               ),
                          //               contentPadding: EdgeInsets.zero,
                          //               content: Stack(
                          //                 children: [
                          //                   Column(
                          //                     mainAxisSize: MainAxisSize.min,
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.start,
                          //                     children: [
                          //                       Padding(
                          //                         padding: EdgeInsets.only(
                          //                           top: 20,
                          //                           left: 10,
                          //                           right: 20,
                          //                           bottom: 10,
                          //                         ),
                          //                         child: Text(
                          //                           'Change your Phone Number',
                          //                           style: TextStyle(
                          //                             fontSize: 18,
                          //                             fontWeight:
                          //                                 FontWeight.bold,
                          //                           ),
                          //                         ),
                          //                       ),
                          //                       Padding(
                          //                         padding: EdgeInsets.symmetric(
                          //                             horizontal: 20,
                          //                             vertical: 10),
                          //                         child: TextField(
                          //                           controller: _phoneNo,
                          //                           decoration: InputDecoration(
                          //                             hintText: 'Phone No',
                          //                             focusedBorder:
                          //                                 OutlineInputBorder(
                          //                               borderRadius:
                          //                                   BorderRadius
                          //                                       .circular(15),
                          //                               borderSide: BorderSide(
                          //                                 color:
                          //                                     Color(0xFFCE5A67),
                          //                                 width: 1,
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                   Positioned(
                          //                     top: 8,
                          //                     right: -10,
                          //                     child: Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           right: 5.0),
                          //                       child: IconButton(
                          //                         icon: Icon(Icons.info),
                          //                         onPressed: () {
                          //                           showDialog(
                          //                               context: context,
                          //                               builder: (BuildContext
                          //                                   context) {
                          //                                 return AlertDialog(
                          //                                   shape:
                          //                                       RoundedRectangleBorder(
                          //                                     borderRadius: BorderRadius
                          //                                         .all(Radius
                          //                                             .circular(
                          //                                                 20.0)),
                          //                                   ),
                          //                                   title: RichText(
                          //                                       text: TextSpan(
                          //                                     text:
                          //                                         'If you changed your phone number your EmailID does not change it will remain as ',
                          //                                     style: TextStyle(
                          //                                         fontSize: 15,
                          //                                         height: 1.3,
                          //                                         color: Colors
                          //                                             .black),
                          //                                     children: <TextSpan>[
                          //                                       TextSpan(
                          //                                         text:
                          //                                             '$email',
                          //                                         style:
                          //                                             TextStyle(
                          //                                           fontSize:
                          //                                               15,
                          //                                           height: 1.3,
                          //                                           color: Color(
                          //                                               0xFFCE5A67),
                          //                                           fontWeight:
                          //                                               FontWeight
                          //                                                   .bold,
                          //                                         ),
                          //                                       ),
                          //                                     ],
                          //                                   )),
                          //                                   actions: [
                          //                                     TextButton(
                          //                                       child:
                          //                                           const Text(
                          //                                         'Cancel',
                          //                                         style:
                          //                                             TextStyle(
                          //                                           fontSize:
                          //                                               15,
                          //                                           height: 1.3,
                          //                                           color: Color(
                          //                                               0xFFCE5A67),
                          //                                           fontWeight:
                          //                                               FontWeight
                          //                                                   .w500,
                          //                                         ),
                          //                                       ),
                          //                                       onPressed: () {
                          //                                         Navigator.of(
                          //                                                 context)
                          //                                             .pop();
                          //                                       },
                          //                                     ),
                          //                                   ],
                          //                                 );
                          //                               });
                          //                         },
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //               actions: <Widget>[
                          //                 TextButton(
                          //                     child: const Text(
                          //                       'OK',
                          //                       style: TextStyle(
                          //                         fontSize: 15,
                          //                         height: 1.3,
                          //                         color: Color(0xFFCE5A67),
                          //                         fontWeight: FontWeight.w500,
                          //                       ),
                          //                     ),
                          //                     onPressed: () async {
                          //                       String newPhoneNumber =
                          //                           _phoneNo.text.trim();

                          //                       // Update phone number in Firestore
                          //                       if (newPhoneNumber.isNotEmpty) {
                          //                         var user = FirebaseAuth
                          //                             .instance.currentUser;
                          //                         String userID = user!.uid;
                          //                         try {
                          //                           await FirebaseFirestore
                          //                               .instance
                          //                               .collection('student')
                          //                               .doc(userID)
                          //                               .update({
                          //                             'PhoneNO': newPhoneNumber
                          //                           });
                          //                         } catch (e) {
                          //                           // Handle error updating phone number in Firestore
                          //                           print(
                          //                               "Error updating phone number in Firestore: $e");
                          //                           return;
                          //                         }
                          //                       }
                          //                       Navigator.of(context).pop();
                          //                     }),
                          //                 TextButton(
                          //                   child: const Text(
                          //                     'Cancel',
                          //                     style: TextStyle(
                          //                       fontSize: 15,
                          //                       height: 1.3,
                          //                       color: Color(0xFFCE5A67),
                          //                       fontWeight: FontWeight.w500,
                          //                     ),
                          //                   ),
                          //                   onPressed: () {
                          //                     Navigator.of(context).pop();
                          //                   },
                          //                 ),
                          //               ],
                          //             );
                          //           });
                          //     },
                          //     child: Container(
                          //       padding: EdgeInsets.fromLTRB(30, 10, 0, 10),
                          //       child: Text(
                          //         'Change your Phone Number',
                          //         style: TextStyle(
                          //           fontSize: 15,
                          //           height: 1.3,
                          //           color: Color(0xFFCE5A67),
                          //           fontWeight: FontWeight.w500,
                          //         ),
                          //       ),
                          //     )),
                          Container(
                              padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                              child: Text(
                                'Room Number\n$roomNo',
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.3,
                                  color: const Color.fromARGB(255, 15, 14, 14),
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        title: Text('Change your Room Number'),
                                        content: TextField(
                                          controller: _roomNo,
                                          decoration: InputDecoration(
                                            hintText: 'Room No',
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
                                        actions: <Widget>[
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
                                            onPressed: () async {
                                              String newroomNumber =
                                                  _roomNo.text.trim();

                                              // Update room number in Firestore
                                              if (newroomNumber.isNotEmpty) {
                                                var user = FirebaseAuth
                                                    .instance.currentUser;
                                                String userID = user!.uid;
                                                try {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('student')
                                                      .doc(userID)
                                                      .update({
                                                    'RoomNo': newroomNumber
                                                  });
                                                } catch (e) {
                                                  // Handle error updating room number in Firestore
                                                  print(
                                                      "Error updating phone number in Firestore: $e");
                                                  return;
                                                }
                                              }

                                              // Dismiss the dialog
                                              Navigator.of(context).pop();
                                            },
                                          ),
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
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                                child: Text(
                                  'Change your Room Number',
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.3,
                                    color: Color(0xFFCE5A67),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )),
                          Container(
                              padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                              child: Text(
                                'Year\n$year',
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.3,
                                  color: const Color.fromARGB(255, 15, 14, 14),
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        title: Text('Change your Year'),
                                        content: TextField(
                                          controller: _year,
                                          decoration: InputDecoration(
                                            hintText: 'Year',
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
                                        actions: <Widget>[
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
                                            onPressed: () async {
                                              String newyear =
                                                  _year.text.trim();

                                              // Update year  in Firestore
                                              if (year.isNotEmpty) {
                                                var user = FirebaseAuth
                                                    .instance.currentUser;
                                                String userID = user!.uid;
                                                try {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('student')
                                                      .doc(userID)
                                                      .update(
                                                          {'Year': newyear});
                                                } catch (e) {
                                                  // Handle error updating year in Firestore
                                                  print(
                                                      "Error updating year in Firestore: $e");
                                                  return;
                                                }
                                              }

                                              // Dismiss the dialog
                                              Navigator.of(context).pop();
                                            },
                                          ),
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
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                                child: Text(
                                  'Change your Year',
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.3,
                                    color: Color(0xFFCE5A67),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )),
                        ]);
                      }
                    });
              }
            }));
  }
}
