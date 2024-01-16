// ignore_for_file: unused_import, unused_local_variable, unnecessary_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Wardenoffice extends StatefulWidget {
  const Wardenoffice({super.key});

  @override
  State<Wardenoffice> createState() => _WardenofficeState();
}

class _WardenofficeState extends State<Wardenoffice> {
  TextEditingController admissionNumberController = TextEditingController();
  Future<DocumentSnapshot>? studentData;
  bool isVisible = false;

  Future<DocumentSnapshot> fetchStudentData(String admissionNumber) async {
    return await FirebaseFirestore.instance
        .collection('student')
        .doc(admissionNumber)
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
            // Add your onPressed logic here
          },
        ),
        title: Text(
          'Name\nWarden',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: admissionNumberController,
                keyboardType: TextInputType.number,
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
                      isVisible = true;
                      String admissionNumber =
                          admissionNumberController.text.trim();
                      if (admissionNumber.isNotEmpty) {
                        setState(() {
                          studentData = fetchStudentData(admissionNumber);
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
                child: Column(
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
                  // Handle 'Rent' payment
                  print('Rent payment selected');
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFCE5A67),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Rent',
                style: TextStyle(
                    color: Colors.black, // Change the color of the text here
                    fontSize: 15,
                  ),),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle 'Mess' payment
                  print('Mess payment selected');
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFCE5A67),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Mess',
                style: TextStyle(
                    color: Colors.black, // Change the color of the text here
                    fontSize: 15,
                  ),),
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
                  print('Rent payment selected');
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFCE5A67),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Rent',
                style: TextStyle(
                    color: Colors.black, // Change the color of the text here
                    fontSize: 15,
                  ),),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle 'Mess' payment
                  print('Mess payment selected');
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFCE5A67),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Mess',
                style: TextStyle(
                    color: Colors.black, // Change the color of the text here
                    fontSize: 15,
                  ),),
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
                  ],
                ),
             
              
              ),
            ],
          ),
        ),
      ),
    );
  }
}