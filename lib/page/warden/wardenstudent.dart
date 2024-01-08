// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_flutter_app/page/warden/register.dart';
import 'package:my_flutter_app/page/warden/warden2.dart';
import 'package:my_flutter_app/page/warden/wardenprofile.dart';

class WardenStudent extends StatefulWidget {
  final String selectedDegree;
  final String selectedYear;

  const WardenStudent(
      {Key? key, required this.selectedDegree, required this.selectedYear})
      : super(key: key);

  @override
  State<WardenStudent> createState() => _WardenStudentState();
}

class _WardenStudentState extends State<WardenStudent> {
  String query = '';
  List<DocumentSnapshot> searchResults = [];

  List<DocumentSnapshot> studentDocuments = [];
  List<bool> isVisibleList = [];
  List<String> degrees = [
    'UG',
    'PG',
    'B.ED',
  ];
  List<String> YearList = ['First', 'Second', 'Third'];
  List<String> items = ['My Profile', 'Log Out'];
  String? dropvalue;

  String? dropdownvalue;
  String? year;

  void initState() {
    super.initState();
    dropdownvalue = widget.selectedDegree;
    year = widget.selectedYear;
    DisplayStudent();
    fetchData();
  }

  void onQueryChanged(String query) {
    setState(() {
      this.query = query;
    });
  }

  Future<void> DisplayStudent() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('student').get();
    setState(() {
      studentDocuments = querySnapshot.docs;
      isVisibleList = List.generate(studentDocuments.length, (_) => false);
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
                }else if (value == 'Log Out')
                  (FirebaseAuth.instance.signOut());
              });
            });
          },
        ),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Warden',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Students',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Row(children: [
                  Container(
                    width: 50,
                    height: 25,
                    child: DropdownButton<String>(
                      value: dropdownvalue,
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      items: degrees.map((String dropdownvalue) {
                        return DropdownMenuItem(
                          value: dropdownvalue,
                          child: Text(
                            dropdownvalue,
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 25,
                    child: DropdownButton<String>(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      value: year,
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      items: YearList.map((String year) {
                        return DropdownMenuItem(
                          value: year,
                          child: Text(
                            year,
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          year = newValue;
                        });
                      },
                    ),
                  ),
                ]),
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
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 23)),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('student')
                        .where('Graduation', isEqualTo: dropdownvalue)
                        .where('Year', isEqualTo: year)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: Color(0xFFCE5A67),
                        ));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error : ${snapshot.error}'));
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
                          shrinkWrap: true,
                          itemCount: filteredStudents.length,
                          itemBuilder: (context, index) {
                            if (filteredStudents.isEmpty) {
                              return Center(child: Text('No students found.'));
                            }
                            if (index >= isVisibleList.length || index < 0) {
                              return SizedBox(); // Return an empty widget if index is out of bounds
                            }
                            final student = filteredStudents[index];
                            return ListTile(
                              title: Column(
                                children: [
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
                                                    ': ${student['Name']}',
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
                                                    ': ${student['RoomNo']}',
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
                                                    ': ${student['PhoneNO']}',
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
                                              Visibility(
                                                visible: isVisibleList[index],
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          child: Text(
                                                            'Blood Group',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              height: 1.3,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      15,
                                                                      14,
                                                                      14),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          ': ${student['BloodGroup']}',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            height: 1.3,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    15,
                                                                    14,
                                                                    14),
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
                                                            'Parent Name',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              height: 1.3,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      15,
                                                                      14,
                                                                      14),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            ':${student['ParentName']}',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              height: 1.3,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      15,
                                                                      14,
                                                                      14),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ))
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
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      15,
                                                                      14,
                                                                      14),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            ': ${student['GPhoneNo']}',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              height: 1.3,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      15,
                                                                      14,
                                                                      14),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isVisibleList[index] =
                                                    !isVisibleList[index];
                                                for (int i = 0;
                                                    i < isVisibleList.length;
                                                    i++) {
                                                  if (i != index) {
                                                    isVisibleList[i] = false;
                                                  }
                                                }
                                              });
                                            },
                                            icon: isVisibleList[index]
                                                ? Icon(Icons.arrow_drop_up)
                                                : Icon(Icons.arrow_drop_down),
                                            color: Colors.black,
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage()),
          );
        },
        backgroundColor: Color(0xFFF4BF96),
        child: const Icon(Icons.add),
      ),
    );
  }
}
