import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class RecordCameraPage extends StatefulWidget {
  @override
  _RecordCameraPageState createState() => _RecordCameraPageState();
}

class _RecordCameraPageState extends State<RecordCameraPage> {
  Map<String, String> _paths;

  void _openFileExplorer() async {
    try {
      _paths = await FilePicker.getMultiFilePath();
    } catch (e) {
      print('Unsupported operation' + e.toString());
    }
    print(_paths);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            onPressed: _openFileExplorer,
            child: Text('GO'),
          ),
        ),
      ),
    );
  }
}
