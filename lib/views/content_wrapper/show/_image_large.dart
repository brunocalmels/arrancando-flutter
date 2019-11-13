import 'package:flutter/material.dart';

class ImageLarge extends StatelessWidget {
  final String tag;
  final String url;

  ImageLarge({
    this.tag,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Center(
          child: Image.network(url),
        ),
      ),
    );
  }
}
