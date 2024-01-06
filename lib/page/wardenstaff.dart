// ignore_for_file: unused_local_variable, unused_import

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/page/register.dart';


class Wardenstaff extends StatefulWidget {
  @override
  _Wardenstaff createState() => _Wardenstaff();
}

class _Wardenstaff extends State<Wardenstaff> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phonenoController = TextEditingController();


  final CollectionReference staffdetails=FirebaseFirestore.instance.collection('Staffdetails');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black, // Set the border color when focused
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromRGBO(244, 191, 150, 1)),
          ),
        ),
      ),
      home: Scaffold(
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'Warden',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Staff',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),

      //floating action button
floatingActionButton: FloatingActionButton(
  onPressed: () {
    // Navigate to RegisterPage on FAB click
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }, // <-- Add the missing closing parenthesis here
  child: Icon(Icons.add),
  backgroundColor: Color.fromRGBO(244, 191, 150, 1),
  foregroundColor: Colors.black,
),


        body:  StreamBuilder(
  stream: staffdetails.snapshots(),
  builder: (context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          final DocumentSnapshot staffdetailssnap = snapshot.data.docs[index];
          return Container(
            height: 100,
             margin: EdgeInsets.all(13), 
             padding: EdgeInsets.all(10),
  decoration: BoxDecoration(
    color: Color.fromRGBO(244, 191, 150, 1),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Color.fromARGB(255, 218, 214, 214),
        blurRadius: 10,
        spreadRadius: 5,
      )
    ]
  ),
           
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(staffdetailssnap ['Name'],style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),),
                  
                   Text(staffdetailssnap ['Phone no'].toString(),style: TextStyle(fontSize: 18),),
                 
                ],
                ),
               Row(
  children: [
    IconButton(
      onPressed: () {
        _showEditDialog(staffdetailssnap.id);
      },
      icon: Icon(Icons.edit),
      iconSize: 30,
      color: Colors.black,
    ),
    IconButton(
      onPressed: () {
        _showDeletionDialog(staffdetailssnap.id);
      },
      icon: Icon(Icons.delete),
      iconSize: 30,
      color: Colors.black,
    ),
  ],
)

              ],

            ),
          );
        },
      );
    }
    return Container();
  },
),

      ),
    );
    
  }

//showinsertion dialog fn declare
  
  //editfunction
  void _showEditDialog(String documentId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit details'),
        content: Container(
          height: 200.0, // Set the height
          width: 300.0, // Set the widthf
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name ',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black, // Set the border color when focused
                    ),
                  ),
                ),
              ),
              TextField(
                controller: _phonenoController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: 'Phone no ',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(0, 0, 0, 0), // Set the border color when focused
                    ),
                  ),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                // Allow only numeric input
              ),
              
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Add your update logic here
              staffdetails.doc(documentId).update({
                'Name': _nameController.text,
                'Phone no': int.parse(_phonenoController.text),
               
              });
              _nameController.clear();
              _phonenoController.clear();
            
              Navigator.of(context).pop(); // Close the dialog
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color.fromRGBO(244, 191, 150, 1)),
              foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 0, 0, 0)),
            ),
            child: Text('Update'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add your cancel logic here
              _nameController.clear();
              _phonenoController.clear();
             
              Navigator.of(context).pop(); // Close the dialog
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color.fromRGBO(244, 191, 150, 1)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}
//deletefunction

void _showDeletionDialog(String documentId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete details'),
        content: Text('Are you sure you want to delete this staff member?'),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Add your delete logic here
              staffdetails.doc(documentId).delete();
              Navigator.of(context).pop(); // Close the dialog
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color.fromRGBO(244, 191, 150, 1)),
              foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 0, 0, 0)),
            ),
            child: Text('Delete'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add your cancel logic here
              Navigator.of(context).pop(); // Close the dialog
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color.fromRGBO(244, 191, 150, 1)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}

}
