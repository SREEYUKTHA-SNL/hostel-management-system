import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/parent/parent_myprofile.dart';
import 'package:my_flutter_app/page/staff/staff1.dart';
import 'package:my_flutter_app/page/student/student1.dart';
import '../staff/staff1.dart';
import 'package:my_flutter_app/page/warden/warden.dart';


class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
  //final user = FirebaseAuth.instance.currentUser;
}

class _AdminPageState extends State<AdminPage> {

 
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
          'Name\nAdmin',
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
            GestureDetector(
                onTap: (){
                Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => WardenPage()),
  );  
                } ,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                //height:100,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFCE5A67),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 50, 48, 48).withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Warden',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
             GestureDetector(
               onTap: (){
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => Student1Page()),
               );  },
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
                   'Student',
                   style: TextStyle(
                     fontSize: 20,
                     color: const Color.fromARGB(255, 15, 14, 14),
                   ),
                 ),
               ),
             ),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: (){
                Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => parent_myprofile()),
  );  },
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
                  'Staff',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30.0),
            
        GestureDetector( onTap: (){
                Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => StaffPage1()),
  );  },
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
                  'Parent',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            
            GestureDetector(
              onTap: (){
                //go to officepage
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
                    'Office',
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
}
