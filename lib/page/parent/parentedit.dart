import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/staff/staff2.dart';
import 'package:my_flutter_app/page/parent/parent_myprofile.dart';

class parentedit extends StatefulWidget {
  const parentedit({super.key});

  @override
  State<parentedit> createState() => _parenteditState();
}

class _parenteditState extends State<parentedit> {
   final _phoneNo = TextEditingController();
  

  List<String> items = ['My Profile', 'Log Out'];
  String? dropvalue;

  Future<QuerySnapshot> getData() async {
    return await FirebaseFirestore.instance.collection('parent').get();
  }

  Future<DocumentSnapshot> getUserData(String userID) async {
    return await FirebaseFirestore.instance
        .collection('parent')
        .doc(userID)
        .get();
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
                    0, 100, 100, 0), 
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
                      MaterialPageRoute(builder: (context) => parent_myprofile()),
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
                      
                      final phoneNo = documents[index]['PhoneNO'];

                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                    color:
                                        const Color.fromARGB(255, 15, 14, 14),
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
                                          title:
                                              Text('Change your Phone Number'),
                                          content: TextField(
                                            controller: _phoneNo,
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
                                                String newPhoneNumber =
                                                    _phoneNo.text.trim();

                                                // Update phone number in Firestore
                                                var user = FirebaseAuth
                                                    .instance.currentUser;
                                                String userID = user!.uid;
                                                try {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'parent')
                                                      .doc(userID)
                                                      .update({
                                                    'PhoneNO': newPhoneNumber
                                                  });
                                                } catch (e) {
                                                  // Handle error updating phone number in Firestore
                                                  print(
                                                      "Error updating phone number in Firestore: $e");
                                                  return;
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
                    });
              }
            }));
  }
}
