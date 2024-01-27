// ignore_for_file: unused_import, unused_local_variable, unnecessary_import

import 'package:flutter_stream_listener/flutter_stream_listener.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class office extends StatefulWidget {
  const office({super.key});

  @override
  State<office> createState() => _officeState();
}

class _officeState extends State<office> {
  TextEditingController admissionNumberController = TextEditingController();
  TextEditingController messBillController = TextEditingController();

  Stream<QuerySnapshot>? studentDataStream;
  bool isVisible = false;
  bool rentVisible = false;
  bool messVisible = false;

  late DocumentReference<Map<String, dynamic>> studentDocRef;

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
            // Add your onPressed logic here
          },
        ),
        title: Text(
          'Name\nOffice',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: admissionNumberController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFCE5A67),
                        width: 3,
                      ),
                    ),
                    labelText: 'Enter Admission Number',
                    border: OutlineInputBorder(),
                    labelStyle: const TextStyle(
                      color: Color(0xFFCE5A67),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        String admissionNumber =
                            admissionNumberController.text.trim();
                        print("Entered Admission Number: $admissionNumber");

                        if (admissionNumber.isNotEmpty) {
                          setState(() {
                            isVisible = true;
                            studentDataStream =
                                listenToStudentData(admissionNumber);
                          });
                        }
                      },
                      icon: Icon(Icons.search, color: Color(0xFFCE5A67)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: isVisible,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: studentDataStream,
                      builder: (context, snapshot) {
                        print("Snapshot Data: ${snapshot.data}");

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error fetching student data'));
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                              child: Text('Invalid Admission Number'));
                        }
                        var studentDocument = snapshot.data!.docs[0];
                        String studentName = studentDocument['Name'];
                        String department = studentDocument['Department'];
                        String year = studentDocument['Year'];
                        int firstRent = studentDocument['FirstRent'];
                        int secondRent = studentDocument['SecondRent'];
                        int messBill = studentDocument['MessBill'];

                        return Column(
                          children: [
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
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('$studentName',
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
                            SizedBox(height: 20),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                            SizedBox(height: 20),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Show a dialog with 'Rent' and 'Mess' options
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Payment'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    rentVisible =
                                                        true; // Set rentVisible to true
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFFCE5A67),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Rent',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .black, // Change the color of the text here
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    messVisible = true;
                                                    rentVisible = false;
                                                  });
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFFCE5A67),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Mess',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .black, // Change the color of the text here
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFCE5A67),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Payment',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                ///////////////////////////////////////
                                ///PAYMENT HISTORY
                                ElevatedButton(
                                  onPressed: () {
                                    // Show a dialog with 'Rent' and 'Mess' options
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Payment History'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Handle 'Rent' payment
                                                  print(
                                                      'Rent payment selected');
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFFCE5A67),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Rent',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .black, // Change the color of the text here
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Handle 'Mess' payment
                                                  print(
                                                      'Mess payment selected');
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFFCE5A67),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Mess',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .black, // Change the color of the text here
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFCE5A67),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Payment History',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Visibility(
                              visible: rentVisible,
                              child: Column(
                                children: [
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
                                          'First Installment',
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
                                        if (studentDocument['FirstRentPay'] ==
                                            true)
                                          Text(
                                            'Paid',
                                            style: TextStyle(
                                              fontSize: 15,
                                              height: 1.3,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        if (studentDocument['FirstRentPay'] ==
                                            false)
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
                                          'Second Installment',
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
                                        if (studentDocument['SecondRentPay'] ==
                                            true)
                                          Text(
                                            'Paid',
                                            style: TextStyle(
                                              fontSize: 15,
                                              height: 1.3,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        if (studentDocument['SecondRentPay'] ==
                                            false)
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
                                  SizedBox(height: 20),
                                  if (studentDocument['FirstRentPay'] ==
                                          false ||
                                      studentDocument['SecondRentPay'] == false)
                                    TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Payment'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Do you want to continue',
                                                    style: TextStyle(
                                                      color: Colors
                                                          .black, // Change the color of the text here
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            bool
                                                                isFirstRentPaid =
                                                                studentDocument[
                                                                        'FirstRentPay'] ==
                                                                    true;
                                                            if (!isFirstRentPaid) {
                                                              await studentDocRef
                                                                  .update({
                                                                'FirstRentPay':
                                                                    true
                                                              });
                                                            } else {
                                                              await studentDocRef
                                                                  .update({
                                                                'SecondRentPay':
                                                                    true
                                                              });
                                                            }
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('OK')),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              Text('Cancel')),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        'Pay',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFCE5A67),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                            Visibility(
                              visible: messVisible,
                              child: Column(
                                children: [
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
                                          'Mess Fee',
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
                                          'Pay Amount',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFFCE5A67),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextField(
                                            controller: messBillController,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Payment'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Do you want to continue',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .black, // Change the color of the text here
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          int messBillValue =
                                                              int.parse(
                                                                  messBillController
                                                                      .text);

                                                          await studentDocRef
                                                              .update({
                                                            'MessBill':
                                                                messBill -
                                                                    messBillValue
                                                          });
                                                          // Navigator.pop(
                                                          //     context);
                                                        },
                                                        child: Text('OK')),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Cancel')),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      'Pay',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xFFCE5A67),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> listenToStudentData(String admissionNumber) {
    var query = FirebaseFirestore.instance
        .collection('student')
        .where('AdmissionNO', isEqualTo: admissionNumber);
    var snapshots = query.snapshots();
    snapshots.listen((event) {
      if (event.docs.isNotEmpty) {
        studentDocRef = event.docs[0].reference;
      }
    });

    return snapshots;
  }
}
