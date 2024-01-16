 import 'package:flutter/material.dart';
 class QRCodeScreen extends StatefulWidget {
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  TextEditingController _textEditingController = TextEditingController();
  String _qrCodeData = 'HostelManagementSystem';

  @override
  Widget build(BuildContext context) {
    var QrVersions;
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Enter text for QR code',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _qrCodeData = _textEditingController.text;
                });
              },
              child: Text('Generate QR Code'),
            ),
            SizedBox(height: 16.0),
            if (_qrCodeData.isNotEmpty)
              Expanded(
                child: Center(
                  child: QrImage(
                    data: _qrCodeData,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

QrImage({required String data, required version, required double size}) {
}