import 'dart:io';

import 'package:flutter/material.dart';

class BottomSheetMultimedia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        children: <Widget>[
          if (!Platform.isLinux)
            Expanded(
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop('camara');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                    Text(
                      'Foto',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.filter,
                    color: Colors.white,
                  ),
                  Text(
                    'Foto',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!Platform.isLinux)
            Expanded(
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop('video');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.filter,
                      color: Colors.white,
                    ),
                    Text(
                      'Video',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
