import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/warden/warden2.dart';
import 'package:my_flutter_app/page/warden/wardenprofile.dart';

class feedetails extends StatefulWidget {
  const feedetails({super.key});

  @override
  State<feedetails> createState() => _feedetailsState();
}

class _feedetailsState extends State<feedetails> {
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
                } else if (value == 'Log Out') _handleLogout();
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
                  'Fee Details',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                  height: 20,
                  child: ToggleButtons(
                    children: [
                      Text(
                        'Paid',
                        style: TextStyle(color: Colors.black, fontSize: 10.0),
                      ),
                      Text(
                        'Unpaid',
                        style: TextStyle(color: Colors.black, fontSize: 10.0),
                      )
                    ],
                    isSelected: isSelected,
                    fillColor: Color(0xFFCE5A67),
                    onPressed: (int newIndex) {
                      setState(() {
                        for (index = 0; index < isSelected.length; index++) {
                          // checking for the index value
                          if (index == newIndex) {
                            // one button is always set to true
                            isSelected[index] = true;
                          } else {
                            // other two will be set to false and not selected
                            isSelected[index] = false;
                          }
                        }
                      });
                    },
                  ),
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
              Visibility(
                visible: isSelected[0],
                child: Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('student')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                            final name =
                                student['Name'].toString().toLowerCase();
                            final roomNo =
                                student['RoomNo'].toString().toLowerCase();
                            final allFields = '$name $roomNo';
                            return (student['FirstRentPay'] ||
                                    (student['FirstRentPay'] &&
                                        student['SecondRentPay'])) &&
                                allFields.contains(query.toLowerCase());
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
                                                        color: const Color
                                                            .fromARGB(
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
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 15, 14, 14),
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                        color: const Color
                                                            .fromARGB(
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
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 15, 14, 14),
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                        color: const Color
                                                            .fromARGB(
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
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 15, 14, 14),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (students['FirstRentPay'] ==
                                                      true &&
                                                  students['SecondRentPay'] ==
                                                      false)
                                                Text(
                                                  'First Installement Paid\nSecond Installment Pending',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    height: 1.3,
                                                    color: const Color.fromARGB(
                                                        255, 15, 14, 14),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              if (students['FirstRentPay'] ==
                                                      true &&
                                                  students['SecondRentPay'] ==
                                                      true)
                                                Text(
                                                  'First and Second Installements Paid',
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
                                        ]))
                              ]));
                            },
                          );
                        }
                      }),
                ),
              ),
              /////////////////////////////////
              Visibility(
                visible: isSelected[1],
                child: Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('student')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                            final name =
                                student['Name'].toString().toLowerCase();
                            final roomNo =
                                student['RoomNo'].toString().toLowerCase();
                            final allFields = '$name $roomNo';
                            final hasPaidRent =
                                student['FirstRentPay'] == false &&
                                    student['SecondRentPay'] == false;
                            return hasPaidRent &&
                                allFields.contains(query.toLowerCase());
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
                                    child: Column(
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
                                                  color: const Color.fromARGB(
                                                      255, 15, 14, 14),
                                                  fontWeight: FontWeight.w500,
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
                                                  color: const Color.fromARGB(
                                                      255, 15, 14, 14),
                                                  fontWeight: FontWeight.w500,
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
                                                  color: const Color.fromARGB(
                                                      255, 15, 14, 14),
                                                  fontWeight: FontWeight.w500,
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
                                      ],
                                    ))
                              ]));
                            },
                          );
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
