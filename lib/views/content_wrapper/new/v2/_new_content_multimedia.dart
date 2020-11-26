import 'dart:io';

import 'package:arrancando/config/services/permissions.dart';
import 'package:arrancando/config/services/utils.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_bottom_sheet_multimedia.dart';
import 'package:arrancando/views/general/_permission_denied_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

class NewContentMultimedia extends StatelessWidget {
  final List<File> images;
  final Function(List<File>) setImages;

  NewContentMultimedia({
    @required this.images,
    @required this.setImages,
  });

  void _openFileExplorer(FileType type) async {
    if (Platform.isIOS) {
      File _image;
      try {
        if (type == FileType.video) {
          _image = await ImagePicker.pickVideo(
            source: ImageSource.gallery,
          );
        } else {
          _image = await ImagePicker.pickImage(
            source: ImageSource.gallery,
          );
        }
      } catch (e) {
        print(e);
      }
      if (_image != null) setImages([...images, File(_image.path)]);
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

  Future<void> _addMultimedia(context) async {
    try {
      final opcion = await showModalBottomSheet(
        context: context,
        builder: (_) => BottomSheetMultimedia(),
      );

      switch (opcion) {
        case 'camara':
          final camaraPermisionDenied =
              !(await PermissionUtils.requestCameraPermission());
          if (!camaraPermisionDenied) {
            final image = await ImagePicker.pickImage(
              source: ImageSource.camera,
              imageQuality: 70,
              maxWidth: 1000,
            );
            if (image != null) setImages([...images, File(image.path)]);
          } else {
            await showDialog(
              context: context,
              builder: (context) => PermissionDeniedDialog(
                mensaje:
                    'El permiso para la cámara fue denegado, para utilizar la cámara cambie los permisos desde la configuración de su dispositivo.',
              ),
            );
          }
          break;
        case 'galeria':
          if (Platform.isLinux) {
            final result = await FilePickerCross.importMultipleFromStorage(
              type: FileTypeCross.any,
              fileExtension: 'png, jpg, jpeg, mp4',
            );
            if (result != null && result.isNotEmpty) {
              final paths = result.map((file) => File(file.path)).toList();
              setImages([...images, ...paths]);
            }
          } else {
            final storagePermisionDenied = Platform.isIOS
                ? !(await PermissionUtils.requestPhotosPermission())
                : !(await PermissionUtils.requestCameraPermission());
            if (!storagePermisionDenied) {
              _openFileExplorer(FileType.image);
            } else {
              await showDialog(
                context: context,
                builder: (context) => PermissionDeniedDialog(
                  mensaje:
                      'El permiso para acceder a los archivos fue denegado, para acceder a los archivos cambie los permisos desde la configuración de su dispositivo.',
                ),
              );
            }
          }
          break;
        case 'video':
          final storagePermisionDenied = Platform.isIOS
              ? !(await PermissionUtils.requestPhotosPermission())
              : !(await PermissionUtils.requestCameraPermission());
          if (!storagePermisionDenied) {
            _openFileExplorer(FileType.video);
          } else {
            await showDialog(
              context: context,
              builder: (context) => PermissionDeniedDialog(
                mensaje:
                    'El permiso para acceder a los archivos fue denegado, para acceder a los archivos cambie los permisos desde la configuración de su dispositivo.',
              ),
            );
          }
          break;
        default:
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Multimedia',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Color(Utils.activeTheme(context) == ThemeMode.light
                    ? 0xffcccccc
                    : 0xff1a1c28),
                offset: Offset(0.0, 0.0),
              ),
              BoxShadow(
                color: Color(Utils.activeTheme(context) == ThemeMode.light
                    ? 0xffeeeeee
                    : 0xff2d3548),
                offset: Offset(0.0, 0.0),
                spreadRadius: -12.0,
                blurRadius: 12.0,
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Subir imágenes o videos',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  color: Color(Utils.activeTheme(context) == ThemeMode.light
                      ? 0xffcccccc
                      : 0xff1a1c28),
                  width: 80,
                  height: 50,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 6,
                      ),
                      child: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  type: MaterialType.card,
                  child: InkWell(
                    onTap: () => _addMultimedia(context),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
