import 'package:flutter/material.dart';

class WardenPage extends StatefulWidget {
  @override
  _WardenPageState createState() => _WardenPageState();
}

class _WardenPageState extends State<WardenPage> {
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
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              //height:100,
             width:200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFCE5A67),
                 boxShadow: [
      BoxShadow(
        color:Color.fromARGB(255, 50, 48, 48).withOpacity(0.2),
        spreadRadius: 3,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
              ),
              child: Text(
                'Students',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 15, 14, 14),
                ),
              ),
            ),
            SizedBox(height: 30.0),
           Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              //height:100,
             width:200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFCE5A67),
              ),
              child: Text(
                'Attendence',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 15, 14, 14),
                ),
              ),
            ),
            SizedBox(height: 30.0),
           Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              //height:100,
             width:200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFCE5A67),
              ),
              child: Text(
                'Fee Details',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 15, 14, 14),
                ),
              ),
            ),
            SizedBox(height: 30.0),
           Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              //height:100,
             width:200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFCE5A67),
              ),
              child: Text(
                'Mess Details',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 15, 14, 14),
                ),
              ),
            ),
            SizedBox(height: 30.0),
           Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              //height:100,
             width:200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFCE5A67),
              ),
              child: Text(
                'Staff',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 15, 14, 14),
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
