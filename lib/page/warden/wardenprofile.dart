import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/warden/wardenedit.dart';

class WardenProfile extends StatefulWidget {
  const WardenProfile({super.key});

  @override
  State<WardenProfile> createState() => _WardenProfileState();
}

class _WardenProfileState extends State<WardenProfile> {

  List<String> items = ['My Profile', 'Log Out'];
  String? dropvalue;
   Future<DocumentSnapshot> getUserData(String userID) async {
    return await FirebaseFirestore.instance
        .collection('Warden')
        .doc(userID)
        .get();
  }
  

  Future<QuerySnapshot> getData() async {
    return await FirebaseFirestore.instance.collection('Warden').get();
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
                    MaterialPageRoute(builder: (context) => WardenProfile()),
                  );
                }
              });
            });
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
                    final name = documents[index]['Name'];
                    final email = documents[index]['Email'];

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
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
                                  SizedBox(height: 5),
                                  Text(
                                    '$name',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Colors.black,
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
                              ))),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Phone No',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Color(0xFFCE5A67),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '$phoneNo',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Colors.black,
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
                              ))),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Color(0xFFCE5A67),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '$email@gmail.com',
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: Colors.black,
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
                              ))),
                               SizedBox(
                            height: 30,
                          ),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 220,
                    padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    child: ElevatedButton(
                      child: Text(
                        "Edit",
                        style: TextStyle(
              color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WardenEdit()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFFCE5A67),
                        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20), // Add some space between buttons
                  Container(
                    width: 220,
                    padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    child: ElevatedButton(
                      child: Text(
                        "Log Out",
                        style: TextStyle(
              color: Colors.black,
                        ),
                      ),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFFCE5A67),
                        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
