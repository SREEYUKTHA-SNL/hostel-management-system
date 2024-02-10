import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Login_page.dart';
import 'package:my_flutter_app/page/warden/warden2.dart';
import 'package:my_flutter_app/page/warden/wardenprofile.dart';

class MessFee extends StatefulWidget {
  const MessFee({super.key});

  @override
  State<MessFee> createState() => _MessFeeState();
}

class _MessFeeState extends State<MessFee> {
  List<String> items = ['My Profile', 'Log Out'];
  String? dropvalue;

  List<bool> isSelected = [true, false];
  int index = 0;
  Stream<QuerySnapshot> studentStream =
      FirebaseFirestore.instance.collection('student').snapshots();

  String query = '';

  List<Map<String, String>> filteredStudents = [];
  List<DocumentSnapshot> searchResults = [];

  String? dropdownvalue;

  @override
  void initState() {
    super.initState();
    dropdownvalue = 'PAID'; // Set the default value here
  }

  void onQueryChanged(String query) {
    setState(() {
      this.query = query;
    });
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
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, authSnapshot) {
                      if (authSnapshot.connectionState ==
                          ConnectionState.waiting) {
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
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('Loading...');
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data == null) {
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
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mess Details',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 15,
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: TextField(
                    onChanged: onQueryChanged,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: "search",
                        hintStyle: TextStyle(
                          fontSize: 12,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 20, 23)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: studentStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFCE5A67),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error :${snapshot.error}'),
                        );
                      } else {
                        final List<DocumentSnapshot> filteredStudents =
                            snapshot.data!.docs.where((student) {
                          final name = student['Name'].toString().toLowerCase();
                          final roomNo =
                              student['RoomNo'].toString().toLowerCase();
                          final allFields = '$name $roomNo';
                          return allFields.contains(query.toLowerCase());
                        }).toList();
                        return ListView.builder(
                          itemCount: filteredStudents.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (filteredStudents.isEmpty) {
                              return Center(
                                child: Text('No students found'),
                              );
                            } else if (index >= filteredStudents.length) {
                              return Center(
                                child: Text("index out of bounds"),
                              );
                            }
                            final students = filteredStudents[index];
                            return ListTile(
                                title: Column(children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  width: 500,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFCE5A67),
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 100,
                                                  child: Text(
                                                    'Name',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      height: 1.3,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 15, 14, 14),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  ': ${students['Name']}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    height: 1.3,
                                                    color: const Color.fromARGB(
                                                        255, 15, 14, 14),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 100,
                                                  child: Text(
                                                    'Room No',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      height: 1.3,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 15, 14, 14),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  ': ${students['RoomNo']}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    height: 1.3,
                                                    color: const Color.fromARGB(
                                                        255, 15, 14, 14),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 100,
                                                  child: Text(
                                                    'Phone No',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      height: 1.3,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 15, 14, 14),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  ': ${students['PhoneNO']}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    height: 1.3,
                                                    color: const Color.fromARGB(
                                                        255, 15, 14, 14),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 100,
                                                  child: Text(
                                                    'Mess Fee',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      height: 1.3,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 15, 14, 14),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  ': ${students['MessBill']}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    height: 1.3,
                                                    color: const Color.fromARGB(
                                                        255, 15, 14, 14),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ]))
                            ]));
                          },
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
