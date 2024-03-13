import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Login_page.dart';
import 'package:my_flutter_app/page/student/student2.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  List<String> items = ['My Profile', 'Log Out'];
  String? dropvalue;

  Future<DocumentSnapshot> getUserData(String userID) async {
    final studentSnapshot = await FirebaseFirestore.instance
        .collection('student')
        .doc(userID)
        .get();

    final adminSnapshot =
        await FirebaseFirestore.instance.collection('Admin').doc(userID).get();

    return adminSnapshot.exists ? adminSnapshot : studentSnapshot;
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
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Login_Page()),
                        (Route<dynamic> route) => false,
                      );
                    });
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
            child: FutureBuilder(
                future: FirebaseAuth.instance.authStateChanges().first,
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child:
                            CircularProgressIndicator()); // Show a loading indicator while fetching data
                  } else if (userSnapshot.hasError) {
                    return Center(child: Text('Error: ${userSnapshot.error}'));
                  } else if (!userSnapshot.hasData ||
                      userSnapshot.data == null) {
                    return Center(child: Text('No Data Available'));
                  } else {
                    final currentUserID = userSnapshot.data!.uid;

                    return FutureBuilder<DocumentSnapshot>(
                        future: getUserData(currentUserID),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return Center(
                                child: Text(
                                    'No data available for the current user'));
                          } else {
                            final name = snapshot.data!['Name'];
                            final department = snapshot.data!['Department'];
                            final year = snapshot.data!['Year'];
                            var firstRent = snapshot.data!['FirstRent'];
                            var firstPaymentDate =
                                snapshot.data!['FirstPaymentDate'];
                            var secondRent = snapshot.data!['SecondRent'];
                            var secondPaymentDate =
                                snapshot.data!['SecondPaymentDate'];
                            var messBill = snapshot.data!['MessBill'];
                            var lastMessPaidDate =
                                snapshot.data!['LastMessPaidDate'];
                            var lastMessPaidAmount =
                                snapshot.data!['LastMessPaidAmount'];
                            return ListView(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('$name',
                                          style: TextStyle(
                                            fontSize: 15,
                                            height: 1.3,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ))
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Department',
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.3,
                                          color: Color(0xFFCE5A67),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('$department',
                                          style: TextStyle(
                                            fontSize: 15,
                                            height: 1.3,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ))
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Year',
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.3,
                                          color: Color(0xFFCE5A67),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('$year',
                                          style: TextStyle(
                                            fontSize: 15,
                                            height: 1.3,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ))
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'First Installment Amount',
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.3,
                                          color: Color(0xFFCE5A67),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('$firstRent',
                                          style: TextStyle(
                                            fontSize: 15,
                                            height: 1.3,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ))
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'First Installment Paid Date',
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.3,
                                          color: Color(0xFFCE5A67),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('$firstPaymentDate',
                                          style: TextStyle(
                                            fontSize: 15,
                                            height: 1.3,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ))
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Second Installment Amount',
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.3,
                                          color: Color(0xFFCE5A67),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('$secondRent',
                                          style: TextStyle(
                                            fontSize: 15,
                                            height: 1.3,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ))
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Second Installment Paid Date',
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.3,
                                          color: Color(0xFFCE5A67),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('$secondPaymentDate',
                                          style: TextStyle(
                                            fontSize: 15,
                                            height: 1.3,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ))
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [Column()],
                                      ),
                                      Text(
                                        'Mess Bill',
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.3,
                                          color: Color(0xFFCE5A67),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('$messBill',
                                          style: TextStyle(
                                            fontSize: 15,
                                            height: 1.3,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ))
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Last Mess Fee Paid Date',
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.3,
                                          color: Color(0xFFCE5A67),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('$lastMessPaidDate',
                                          style: TextStyle(
                                            fontSize: 15,
                                            height: 1.3,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ))
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Last Mess Fee Paid Amount',
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.3,
                                          color: Color(0xFFCE5A67),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('$lastMessPaidAmount',
                                          style: TextStyle(
                                            fontSize: 15,
                                            height: 1.3,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ))
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        });
                  }
                })));
  }
}
