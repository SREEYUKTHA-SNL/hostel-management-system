import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/warden/warden2.dart';
import 'package:my_flutter_app/page/warden/wardenprofile.dart';

class WardenAttendance extends StatefulWidget {
  const WardenAttendance({super.key});

  @override
  State<WardenAttendance> createState() => _WardenAttendanceState();
}

class _WardenAttendanceState extends State<WardenAttendance> {
  bool light = false;
  String query = '';
  List<bool> isSelected = [true, false];
  int index = 0;

  void onQueryChanged(String query) {
    setState(() {
      this.query = query;
    });
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
                  } else if (value == 'Log Out')
                    (FirebaseAuth.instance.signOut());
                });
              });
            },
          ),
          title: Row(children: [
            FutureBuilder<User?>(
                future: FirebaseAuth.instance.authStateChanges().first,
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  } else {
                    final currentUserID = userSnapshot.data!.uid;

                    return FutureBuilder<DocumentSnapshot>(
                      future: getUserData(currentUserID),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
            Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 5,
              ),
              Text(
                'Attendance',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 20,
                child: ToggleButtons(
                  children: [
                    Text(
                      'IN',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.0,
                      ),
                    ),
                    Text(
                      'OUT',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.0,
                      ),
                    )
                  ],
                  isSelected: isSelected,
                  fillColor: Color(0xFFCE5A67),
                  onPressed: (int newIndex) {
                    setState(() {
                      // looping through the list of booleans values
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
                height: 10,
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
                      hintText: "search by room or name",
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 23)),
                ),
              )
            ])
          ])),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Visibility(
                visible: isSelected[0],
                child: Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('student')
                          .where('Attendance', isEqualTo: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFFCE5A67)),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error : ${snapshot.error}'),
                          );
                        } else {
                          final List<DocumentSnapshot> filteredStudents =
                              snapshot.data!.docs.where((student) {
                            final name =
                                student['Name'].toString().toLowerCase();
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
                                              )
                                            ],
                                          ),
                                        ]))
                              ]));
                            },
                          );
                        }
                      }),
                )),
            Visibility(
                visible: isSelected[1],
                child: Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('student')
                          .where('Attendance', isEqualTo: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFFCE5A67)),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error : ${snapshot.error}'),
                          );
                        } else {
                          final List<DocumentSnapshot> filteredStudents =
                              snapshot.data!.docs.where((student) {
                            final name =
                                student['Name'].toString().toLowerCase();
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
                                              )
                                            ],
                                          ),
                                        ]))
                              ]));
                            },
                          );
                        }
                      }),
                ))
          ],
        ),
      )),
    );
  }
}
