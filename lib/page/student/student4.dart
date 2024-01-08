import 'package:flutter/material.dart';

class DynamicButtonsDialog extends StatefulWidget {
  @override
  _DynamicButtonsDialogState createState() => _DynamicButtonsDialogState();
}

class _DynamicButtonsDialogState extends State<DynamicButtonsDialog> {
  bool showButtons = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 180.0,
        height: showButtons ? 180.0 : 80.0,
        child: showButtons
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print("Button 1 clicked");
                    },
                    child: Text('Yes'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("Button 2 clicked");
                    },
                    child: Text('No'),
                  ),
                  
                ],
              )
            : ElevatedButton(
                onPressed: () {
                  setState(() {
                    showButtons = true;
                  });
                },
                child: Text('poll'),
              ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
