import 'package:flutter/material.dart';

class ImageUserProfile extends StatelessWidget {
  final AssetImage src;
  final String label;

  ImageUserProfile({
    @required this.src,
    @required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: src != null
                    ? Image(
                        image: src,
                      )
                    : Center(
                        child: Icon(Icons.camera_alt),
                      ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    color: Theme.of(context).primaryColor.withAlpha(200),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      label.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
