// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class parent_student extends StatefulWidget {
  const parent_student({super.key});

  @override
  State<parent_student> createState() => _parent_studentState();
}

class _parent_studentState extends State<parent_student> {
    List<String> items = ['My Profile', 'Log Out'];
  String? dropvalue;
   Future<DocumentSnapshot> getUserData(String userID) async {
    return await FirebaseFirestore.instance
        .collection('student')
        .doc(userID)
        .get();
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
            Icons.escalator_warning,
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
                    MaterialPageRoute(builder: (context) => parent_student()),
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
            } else if (userSnapshot.hasError) {
              return Text('Error: ${userSnapshot.error}');
            } else if (!userSnapshot.hasData || userSnapshot.data == null) {
              return Text('Name\nParent');
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
                    return Text('Name\nParent');
                  } else {
                    final userName = snapshot.data![
                        'Name']; // Replace 'Name' with your actual field name

                    return Text(
                      '$userName\nParent',
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
      backgroundColor: const Color(0xFFFCF5ED),
      body: FutureBuilder<QuerySnapshot>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show a loading indicator while fetching data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text('No Data Available');
            } else {
              List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final studentName = documents[index]['Name'];
                    final phoneNo = documents[index]['PhoneNO'];
                    final roomNo = documents[index]['RoomNo'];
                    final Mess = documents[index]['MessFee'];
                    final Fee = documents[index]['Fee'];
                    

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                    '$studentName',
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
                                    'PhoneNo',
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
                                    'Room No',
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
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mess Fee',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Color(0xFFCE5A67),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '$Mess',
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
                          
                         
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rent Fee',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Color(0xFFCE5A67),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '$Fee',
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
                            height: 30,
                          ),
                          
                        ]);
                  });
            }
          }),
    );
  }
}
