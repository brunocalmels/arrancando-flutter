import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCabecera extends StatelessWidget {
  final String src;

  ImageCabecera({
    @required this.src,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(MediaQuery.of(context).size.width),
        bottomRight: Radius.circular(MediaQuery.of(context).size.width),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        child: src != null
            ? CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: src,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
            : Center(
                child: Icon(Icons.camera_alt),
              ),
      ),
    );
  }
}
