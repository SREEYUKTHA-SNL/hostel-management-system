import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScannerPage extends StatefulWidget {
  @override
  _QrCodeScannerPageState createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends State<QrCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String result = "";
  bool isCheckedIn = false;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<DocumentSnapshot> getUserData(String userID) async {
    return await FirebaseFirestore.instance
        .collection('student')
        .doc(userID)
        .get();
  }

    Future<void> updateAttendanceInFirestore() async {
    try {
      // Assuming you have a collection named 'students' in Firestore
      CollectionReference students = _firestore.collection('student');

      // Replace 'STUDENT_ID' with the actual ID or a unique identifier of the student
      String studentId = FirebaseAuth.instance.currentUser!.uid;

      // Get the document reference for the specific student
      DocumentReference studentRef = students.doc(studentId);

      // Update the attendance field based on isCheckedIn status
      await studentRef.update({'Attendance': isCheckedIn});

      // Update the result text widget
      setState(() {
        result = isCheckedIn ? 'Checked In' : 'Checked Out';
      });
    } catch (e) {
      print('Error updating attendance: $e');
    }
    }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code!;
        // Check if the scanned QR code is correct before executing the method
        if (result == 'NOTAHMSassd4035525') {
          // Toggle the check-in status on each scan
          isCheckedIn = !isCheckedIn;

          // Run the method for the correct QR code
          updateAttendanceInFirestore();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Scan QR Code',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFCE5A67),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.fromLTRB(30, 50, 30, 50),
                  height: 350,
                  width: 250,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.white,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 250,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Result: $result'),
                SizedBox(height: 16),
                Text('Student is Checked ${isCheckedIn ? 'In' : 'Out'}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
