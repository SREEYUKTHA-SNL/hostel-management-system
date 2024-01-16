import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/codeQr.dart';
import 'package:my_flutter_app/page/student/student2.dart';
import 'package:my_flutter_app/page/warden/wardenprofile.dart';

class Student1Page extends StatefulWidget {
  @override
  _Student1PageState createState() => _Student1PageState();
}

class _Student1PageState extends State<Student1Page> {
  List<String> items = ['My Profile', 'Log Out'];
  String? dropvalue;

  Future<DocumentSnapshot> getUserData(String userID) async {
    return await FirebaseFirestore.instance
        .collection('student')
        .doc(userID)
        .get();
  }

  Future<void> MessOut(User user) async {
    try {
      String? userID = user.uid;
      await FirebaseFirestore.instance
          .collection('student')
          .doc(userID)
          .update({'Mess': false});
    } catch (e) {
      print('Error polling mess out: $e');
    }
  }

  Future<void> MessBill(User user) async {
    try {
      String? userID = user.uid;

      // Get the current messBill value from Firestore
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('student')
          .doc(userID)
          .get();

      int currentMessBill = documentSnapshot.get('MessBill') ?? 0;

      // Update messBill and set Mess field to true
      await FirebaseFirestore.instance
          .collection('student')
          .doc(userID)
          .update({
        'MessBill': currentMessBill + 90,
        'Mess': true,
      });
    } catch (e) {
      print('Error updating mess bill: $e');
      // Handle the error accordingly
    }
  }

  bool showButtons = false;

  Future<void> getFeeData(User user) async {
    try {
      String userID = user.uid;
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('student')
          .doc(userID)
          .get();

      int firstRentFee = documentSnapshot.get('FirstRent') ?? 0;
      int secondRentFee = documentSnapshot.get('SecondRent') ?? 0;
      int messFee = documentSnapshot.get('MessBill') ?? 0;

      int total = firstRentFee + secondRentFee + messFee;
      int rentFee = firstRentFee + secondRentFee;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFFFCF5ED),
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: 180.0,
              height: 180.0,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Rent: $rentFee"),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Mess: $messFee"),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Total: $total"),
                  ),
                ],
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
    } catch (e) {
      print('Error retrieving fee data: $e');
      // Handle the error accordingly
    }
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
                    MaterialPageRoute(builder: (context) => Student2Page()),
                  );
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
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Student2Page()));
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
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          backgroundColor: Color(0xFFFCF5ED),
                          contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                15.0), // Set your desired border radius here
                          ),
                          content: Container(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: showButtons
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            MessBill(FirebaseAuth
                                                .instance.currentUser!);
                                            Navigator.pop(context);
                                            showButtons = false;
                                          },
                                          child: Text('Mess In',
                                              style: TextStyle(
                                                color: Color(0xFFCE5A67),
                                              )),
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)))),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            MessOut(FirebaseAuth
                                                .instance.currentUser!);
                                            Navigator.pop(context);
                                            showButtons = false;
                                          },
                                          child: Text(
                                            'Mess Out',
                                            style: TextStyle(
                                              color: Color(0xFFCE5A67),
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)))),
                                    ],
                                  )
                                : TextButton(
                                    onPressed: () {
                                      setState(() {
                                        showButtons = true;
                                      });
                                    },
                                    child: Text(
                                      'Poll Here',
                                      style: TextStyle(
                                        color: Color(0xFFCE5A67),
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)))),
                          ),
                          actions: <Widget>[
                            SizedBox(
                              height: 50,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showButtons = false;
                                },
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                    color: Color(0xFFCE5A67),
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                          ],
                        );
                      });
                    });
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
                  'Mess details',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                //height:100,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFCE5A67),
                ),
                child: GestureDetector(
                  onTap: () {
                    getFeeData(FirebaseAuth.instance.currentUser!);
                  },
                  child: Text(
                    'Fee Details',
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 15, 14, 14),
                    ),
                  ),
                )),
            SizedBox(height: 30.0),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              //height:100,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFCE5A67),
              ),
              child: GestureDetector(
                onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (context)=>QrCodeScannerPage()));
                },
                child: Text(
                  'Attendece',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
