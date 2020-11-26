import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPicker extends StatefulWidget {
  final Function(String) setAvatar;
  final ImageProvider currentAvatar;

  AvatarPicker({
    @required this.setAvatar,
    this.currentAvatar,
  });

  @override
  _AvatarPickerState createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  File _image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  onPressed: () async {
                    try {
                      if (mounted) {
                        final opcion = await showModalBottomSheet(
                          backgroundColor: Colors.white,
                          builder: (BuildContext context) {
                            return Container(
                              height: 100,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop('camara');
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.camera_alt),
                                          Text('Cámara'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop('galeria');
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.filter),
                                          Text('Galería'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          context: context,
                        );

                        switch (opcion) {
                          case 'camara':
                            _image = await ImagePicker.pickImage(
                              source: ImageSource.camera,
                              imageQuality: 70,
                              maxWidth: 1000,
                            );
                            break;
                          case 'galeria':
                            _image = await ImagePicker.pickImage(
                              source: ImageSource.gallery,
                            );
                            break;
                          default:
                        }

                        if (_image != null) {
                          final base64Image = base64Encode(
                            File(_image.path).readAsBytesSync(),
                          );

                          widget.setAvatar(base64Image);
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null
                        ? FileImage(File(_image.path))
                        : widget.currentAvatar,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                'Cambiar avatar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
