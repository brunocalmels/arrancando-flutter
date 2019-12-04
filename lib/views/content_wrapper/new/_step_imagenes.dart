import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class StepImagenes extends StatelessWidget {
  final List<File> images;
  final Function setImages;
  final Function removeImage;

  StepImagenes({
    @required this.images,
    @required this.setImages,
    @required this.removeImage,
  });
  void _openFileExplorer(FileType type) async {
    Map<String, String> _paths;

    try {
      _paths = await FilePicker.getMultiFilePath(type: type);
    } catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (_paths != null && _paths.length > 0)
      setImages([...images, ..._paths.values.map((p) => File(p)).toList()]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 150,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (images.length == 0)
                  Text(
                    'No hay imágenes seleccionadas',
                    textAlign: TextAlign.center,
                  ),
                FlatButton(
                  onPressed: () => _openFileExplorer(FileType.IMAGE),
                  child: Text("SELECCIONAR IMÁGENES"),
                ),
                FlatButton(
                  onPressed: () => _openFileExplorer(FileType.VIDEO),
                  child: Text("SELECCIONAR VIDEOS"),
                ),
              ],
            ),
          ),
        ),
        if (images.length > 0)
          Wrap(
            direction: Axis.horizontal,
            children: images
                .map(
                  (asset) => Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      color: Colors.black12,
                      padding: const EdgeInsets.all(2),
                      width: (MediaQuery.of(context).size.width - 32) / 3.5,
                      height: (MediaQuery.of(context).size.width - 32) / 3.5,
                      child: Stack(
                        fit: StackFit.passthrough,
                        children: <Widget>[
                          [
                            'mp4',
                            'mpg',
                            'mpeg'
                          ].contains(asset.path.split('.').last.toLowerCase())
                              ? FutureBuilder(
                                  future: VideoThumbnail.thumbnailData(
                                    video: asset.path,
                                    imageFormat: ImageFormat.JPEG,
                                    maxHeightOrWidth:
                                        ((MediaQuery.of(context).size.width -
                                                    32) /
                                                3.5)
                                            .floor(),
                                    quality: 70,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Stack(
                                        fit: StackFit.passthrough,
                                        children: <Widget>[
                                          Image.memory(snapshot.data),
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
                                      height: 25,
                                      width: 25,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Image.file(asset),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => removeImage(asset),
                              child: Icon(
                                Icons.delete,
                                color: Color(0xccff0000),
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
