import 'dart:io';

import 'package:arrancando/config/globals/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ContentThumb extends StatelessWidget {
  final dynamic asset;
  final Map<String, String> currentVideoThumbs;

  ContentThumb({
    @required this.asset,
    this.currentVideoThumbs,
  });

  Widget _buildThumb(BuildContext context, dynamic asset) {
    if (asset is File && asset.path != null) {
      return MyGlobals.VIDEO_FORMATS
              .contains(asset.path.split('.').last.toLowerCase())
          ? FutureBuilder(
              future: VideoThumbnail.thumbnailData(
                video: asset.path,
                imageFormat: ImageFormat.JPEG,
                maxHeight:
                    ((MediaQuery.of(context).size.width - 32) / 3.5).floor(),
                maxWidth:
                    ((MediaQuery.of(context).size.width - 32) / 3.5).floor(),
                quality: 70,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      Image.memory(
                        snapshot.data,
                        fit: BoxFit.cover,
                      ),
                      Center(
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      )
                    ],
                  );
                }
                return SizedBox(
                  height: 5,
                  width: 5,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
            )
          : Image.file(
              asset,
              fit: BoxFit.cover,
            );
    } else if (asset is String) {
      return MyGlobals.VIDEO_FORMATS
              .contains(asset.split('.').last.toLowerCase())
          ? currentVideoThumbs != null && currentVideoThumbs[asset] == null
              ? SizedBox(
                  height: 25,
                  width: 25,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl:
                          '${MyGlobals.SERVER_URL}${currentVideoThumbs[asset]}',
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
                    ),
                    Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                    )
                  ],
                )
          : CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: '${MyGlobals.SERVER_URL}$asset',
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
            );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return _buildThumb(context, asset);
  }
}
