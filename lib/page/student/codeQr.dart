import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/parent/notifications.dart';
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
  bool mess = false;
  bool scanCompleted = false; // Variable to track if scan completed
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getUserData(String userID) async {
    return await FirebaseFirestore.instance
        .collection('student')
        .doc(userID)
        .get();
  }

  @override
  void initState() {
    super.initState();
    getUserData(FirebaseAuth.instance.currentUser!.uid).then((snapshot) {
      setState(() {
        isCheckedIn = snapshot['Attendance'] ? false : true;
        mess = snapshot['Mess'] ? false : true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _sendNotificationToParent(String parentUserId) async {
    // Implement your logic to send notification to the parent using the parentUserId
    // For example, you can use Firebase Cloud Messaging (FCM) to send the notification
    // You'll need to have the parent's device token or FCM registration ID to send the notification
    // This is a simplified example to demonstrate the concept

    LocalNotifications.showNotification(
        title: "Notificatons",
        body: "You are checked ${isCheckedIn ? 'In' : 'Out'}",
        payload: "this is simple");
    print('Sending notification to parent with UserID: $parentUserId');
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!scanCompleted) {
        result = scanData.code!;
        if (result == 'NOTAHMSassd4035525') {
          setState(() {
            isCheckedIn = !isCheckedIn; // Toggle isCheckedIn variable
            mess = isCheckedIn; // Update mess accordingly
          });

          String studentId = FirebaseAuth.instance.currentUser!.uid;
          CollectionReference students = _firestore.collection('student');
          QuerySnapshot<Map<String, dynamic>> parentQuerySnapshot =
              await _firestore
                  .collection('parent')
                  .where('StudentID', isEqualTo: studentId)
                  .get();
          for (QueryDocumentSnapshot<Map<String, dynamic>> parentSnapshot
              in parentQuerySnapshot.docs) {
            String parentUserId = parentSnapshot['UserId'];
            _sendNotificationToParent(parentUserId);
          }

          print("parent =        $parentQuerySnapshot");
          students.doc(studentId).update({
            'Attendance': isCheckedIn,
            'Mess': mess
          }); // Update attendance and mess in Firestore
          setState(() {
            result = isCheckedIn ? 'Checked In' : 'Checked Out';
          });
          scanCompleted = true;
        }
      }
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
                Text('Student is Checked ${isCheckedIn ? 'In' : 'Out'}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
