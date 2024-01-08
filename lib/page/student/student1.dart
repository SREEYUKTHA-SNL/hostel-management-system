import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/student/student3.dart';
import 'package:my_flutter_app/page/warden/wardenprofile.dart';

class Student1Page extends StatefulWidget {
  @override
  _Student1PageState createState() => _Student1PageState();
}

class _Student1PageState extends State<Student1Page> {
  List<String> items = ['My Profile', 'Log Out'];
  String? dropvalue;

  bool showButtons = false;
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
                    MaterialPageRoute(builder: (context) => Student1Page()),
                  );
                } else if (value == 'Log Out')
                  (FirebaseAuth.instance.signOut());
              });
            });
          },
        ),
        title: Text(
          'Name\nStudent',
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
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Student3Page()));
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
                  'My Profile',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              //height:100,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFCE5A67),
              ),

              child: GestureDetector(
                child: Text(
                  'Mess details',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 15, 14, 14),
                  ),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            backgroundColor: Color(0xFFF4BF96),
                            contentPadding: EdgeInsets.zero,
                            content: Container(
                              width: 180.0,
                              height: showButtons ? 180.0 : 50.0,
                              child: showButtons
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            print("Button 1 clicked");
                                          },
                                          child: Text('Yes',
                                              style: TextStyle(
                                                color: Colors.black,
                                              )),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            print("Button 2 clicked");
                                          },
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          showButtons = true;
                                        });
                                      },
                                      child: Text(
                                        'poll',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                            ),
                            actions: <Widget>[
                              SizedBox(
                                height: 50,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                      });
                },
              ),
            ),
            SizedBox(height: 30.0),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                //height:100,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFCE5A67),
                ),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          content: Container(
                            width: 180.0, // Set your desired width
                            height: 180.0, // Set your desired height
                            child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    // Handle Option 1
                                    print("Option 1");
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(" Rent:"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Handle Option 2
                                    print("Option 2");
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text("   Mess:"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Handle Option 3
                                    print("Option 3");
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text("   Total:"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the AlertDialog
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Fee Details',
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 15, 14, 14),
                    ),
                  ),
                )),
            SizedBox(height: 30.0),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              //height:100,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFCE5A67),
              ),
              child: Text(
                'Attendece',
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
