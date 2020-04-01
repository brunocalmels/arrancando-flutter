import 'dart:io';

import 'package:arrancando/views/content_wrapper/new/v2/_content_thumb.dart';
import 'package:flutter/material.dart';

class MultimediaThumbs extends StatelessWidget {
  final List<File> images;
  final List<String> currentImages;
  final Map<String, String> currentVideoThumbs;
  final Function(File) removeImage;
  final Function(String) removeCurrentImage;
  final List<String> imagesToRemove;

  MultimediaThumbs({
    @required this.images,
    this.currentImages,
    this.currentVideoThumbs,
    this.removeImage,
    this.removeCurrentImage,
    this.imagesToRemove,
  });

  @override
  Widget build(BuildContext context) {
    return (images != null && images.length > 0) ||
            (currentImages != null && currentImages.length > 0)
        ? Padding(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              spacing: MediaQuery.of(context).size.width * 0.05,
              runSpacing: MediaQuery.of(context).size.width * 0.05,
              direction: Axis.horizontal,
              children: [...currentImages, ...images]
                  .map(
                    (asset) => asset != null
                        ? Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Colors.black,
                                )
                              ],
                            ),
                            width: MediaQuery.of(context).size.width * 0.135,
                            height: MediaQuery.of(context).size.width * 0.135,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                              child: Stack(
                                fit: StackFit.passthrough,
                                children: <Widget>[
                                  ContentThumb(
                                    asset: asset,
                                    currentVideoThumbs: currentVideoThumbs,
                                  ),
                                  if (removeImage != null && asset is File)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () => removeImage(asset),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4,
                                                color: Colors.black,
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (removeCurrentImage != null &&
                                      asset is String)
                                    Positioned.fill(
                                      child: GestureDetector(
                                        onTap: () => removeCurrentImage(asset),
                                        child: Opacity(
                                          opacity:
                                              imagesToRemove.contains(asset)
                                                  ? 0.8
                                                  : 0.5,
                                          child: Container(
                                            color:
                                                imagesToRemove.contains(asset)
                                                    ? Colors.black
                                                    : null,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  )
                  .toList(),
            ),
          )
        : Container();
  }
}
