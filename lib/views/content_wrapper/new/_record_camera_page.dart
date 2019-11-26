import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class RecordCameraPage extends StatefulWidget {
  @override
  _RecordCameraPageState createState() => _RecordCameraPageState();
}

class _RecordCameraPageState extends State<RecordCameraPage> {
  List<CameraDescription> _cameras;
  CameraController _controller;
  String videoPath;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  _initCameras() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras[0],
      ResolutionPreset.low,
      enableAudio: false,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<String> startVideoRecording() async {
    if (!_controller.value.isInitialized) {
      showInSnackBar('Error: seleccionar una cámara.');
      return null;
    }

    final Directory extDir = await getExternalStorageDirectory();
    final String dirPath = '${extDir.path}/Movies';
    await Directory(dirPath).create(recursive: true);
    final String filePath =
        '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}.mp4';

    if (_controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await _controller.startVideoRecording(filePath);
      if (mounted) setState(() {});
      if (filePath != null) showInSnackBar('Guardando video en $filePath');
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<void> stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await _controller.stopVideoRecording();
      if (mounted) setState(() {});
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initCameras();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _controller == null || !_controller.value.isInitialized
          ? Container()
          : Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: CameraPreview(_controller),
                ),
                Positioned(
                  bottom: 45,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          iconSize: 60,
                          onPressed: () {
                            if (_controller.value.isRecordingVideo) {
                              stopVideoRecording();
                            } else {
                              startVideoRecording();
                            }
                          },
                          icon: Icon(
                            Icons.fiber_manual_record,
                            color: _controller.value.isRecordingVideo
                                ? Colors.red
                                : Colors.lightGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
