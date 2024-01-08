import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/staff/staffprofile.dart';
import 'package:my_flutter_app/page/warden/warden2.dart';
import 'package:my_flutter_app/page/staff/staffedit.dart';

class StaffPage2 extends StatefulWidget {
  @override
  _StaffPage2State createState() => _StaffPage2State();
}

class _StaffPage2State extends State<StaffPage2> {
  List<String> items = ['My Profile', 'Log Out'];
  String? dropvalue;

  Future<DocumentSnapshot> getUserData(String userID) async {
    return await FirebaseFirestore.instance
        .collection('staffdetails')
        .doc(userID)
        .get();
  }

  Future<String> fetchData() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('student').get();
    final int documents = snapshot.docs.length;
    return documents.toString();
  }

  Future<String> MessIn() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('student')
        .where('Mess', isEqualTo: true)
        .get();
    final int attandanded = snapshot.docs.length;
    return attandanded.toString();
  }

  Future<String> MessOut() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('student')
        .where('Mess', isEqualTo: false)
        .get();
    final int attandanded = snapshot.docs.length;
    return attandanded.toString();
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
            Icons.groups,
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StaffProfile()));
                } else if (value == 'Log Out')
                  (FirebaseAuth.instance.signOut());
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
                return Text('Name\nStaff');
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
                      return Text('Name\nStaff');
                    } else {
                      final userName = snapshot.data!['Name'];

                      return Text(
                        '$userName\nStaff',
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
              height: 90,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StaffProfile()));
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
                  'My Profile',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.0),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFCE5A67),
              ),
              child: GestureDetector(
                onTap: () {
                  _showAlertDialog();
                },
                child: Text(
                  'Mess Poll',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.0),
            GestureDetector(
              onTap: () {
                //go to the page of scanning qr code for marking attendance
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                //height:100,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFCE5A67),
                ),
                child: Text(
                  'Check In',
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

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFCF5ED),
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Text("No of students:"),
                      FutureBuilder<String>(
                          future: fetchData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                snapshot.data!,
                              );
                            }
                          })
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text("Mess In:"),
                      FutureBuilder<String>(
                          future: MessIn(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                snapshot.data!,
                              );
                            }
                          })
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text("Mess Out:"),
                      FutureBuilder<String>(
                          future: MessOut(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                snapshot.data!,
                              );
                            }
                          })
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the AlertDialog
              },
              child: Text(
                'Close',
                style: TextStyle(color: Color(0xFFCE5A67)),
              ),
            ),
          ],
        );
      },
    );
  }
}
