import 'dart:io';

import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
    if (Platform.isIOS) {
      PickedFile _image;
      try {
        _image = await ImagePicker().getImage(
          source: ImageSource.gallery,
        );
      } catch (e) {
        print(e);
      }
      if (_image != null) setImages([...images, _image]);
    } else {
      Map<String, String> _paths;

      try {
        _paths = await FilePicker.getMultiFilePath(type: type);
      } catch (e) {
        print('Unsupported operation' + e.toString());
      }
      if (_paths != null && _paths.isNotEmpty) {
        setImages([...images, ..._paths.values.map((p) => File(p)).toList()]);
      }
    }
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
                if (images.isEmpty)
                  Text(
                    'No hay imágenes seleccionadas',
                    textAlign: TextAlign.center,
                  ),
                FlatButton(
                  // onPressed: () => _openFileExplorer(FileType.IMAGE),
                  onPressed: () async {
                    try {
                      final opcion = await showModalBottomSheet(
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
                          final camaraPermisionDenied =
                              await ActiveUser.cameraPermissionDenied();
                          if (!camaraPermisionDenied) {
                            final image = await ImagePicker().getImage(
                              source: ImageSource.camera,
                              imageQuality: 70,
                              maxWidth: 1000,
                            );
                            if (image != null) setImages([...images, image]);
                          } else {
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Permiso denegado'),
                                content: Text(
                                  'El permiso para la cámara fue denegado, para utilizar la cámara cambie los permisos desde la configuración de su dispositivo.',
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Aceptar'),
                                  )
                                ],
                              ),
                            );
                          }
                          break;
                        case 'galeria':
                          _openFileExplorer(FileType.image);
                          break;
                        default:
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text('SELECCIONAR IMÁGENES'),
                ),
                FlatButton(
                  onPressed: () => _openFileExplorer(FileType.video),
                  child: Text('SELECCIONAR VIDEOS'),
                ),
              ],
            ),
          ),
        ),
        if (images.isNotEmpty)
          Wrap(
            direction: Axis.horizontal,
            children: images
                .map(
                  (asset) => asset != null && asset.path != null
                      ? Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            color: Colors.black12,
                            padding: const EdgeInsets.all(2),
                            width:
                                (MediaQuery.of(context).size.width - 32) / 3.5,
                            height:
                                (MediaQuery.of(context).size.width - 32) / 3.5,
                            child: Stack(
                              fit: StackFit.passthrough,
                              children: <Widget>[
                                MyGlobals.VIDEO_FORMATS.contains(asset.path
                                        .split('.')
                                        .last
                                        .toLowerCase())
                                    ? FutureBuilder(
                                        future: VideoThumbnail.thumbnailData(
                                          video: asset.path,
                                          imageFormat: ImageFormat.JPEG,
                                          maxHeightOrWidth:
                                              ((MediaQuery.of(context)
                                                              .size
                                                              .width -
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
                        )
                      : Container(),
                )
                .toList(),
          ),
      ],
    );
  }
}
