import 'package:arrancando/views/content_wrapper/new/_record_camera_page.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class StepImagenes extends StatefulWidget {
  final List<Asset> images;
  final Function setImages;
  final Function(Function) createdCallback;

  StepImagenes({
    @required this.images,
    @required this.setImages,
    this.createdCallback,
  });

  @override
  _StepImagenesState createState() => _StepImagenesState();
}

class _StepImagenesState extends State<StepImagenes> {
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: false,
        selectedAssets: widget.images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarTitle: "Seleccionar imágenes",
          allViewTitle: "Todas",
          useDetailsView: false,
        ),
      );

      for (var r in resultList) {
        var t = await r.filePath;
        print(t);
      }
    } on Exception catch (e) {
      print(e);
    }

    if (!mounted) return;

    if (resultList.length > 0) widget.setImages(resultList);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAssets();
      if (widget.createdCallback != null) widget.createdCallback(loadAssets);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: widget.images.length == 0
              ? Container(
                  height: 150,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'No hay imágenes seleccionadas',
                          textAlign: TextAlign.center,
                        ),
                        FlatButton(
                          onPressed: loadAssets,
                          child: Text("SELECCIONAR"),
                        ),
                      ],
                    ),
                  ),
                )
              : Wrap(
                  direction: Axis.horizontal,
                  children: widget.images
                      .map(
                        (asset) => Padding(
                          padding: const EdgeInsets.all(2),
                          child: AssetThumb(
                            asset: asset,
                            width:
                                (MediaQuery.of(context).size.width - 40) ~/ 3.2,
                            height:
                                (MediaQuery.of(context).size.width - 40) ~/ 3.2,
                            spinner: Container(
                              width: (MediaQuery.of(context).size.width - 45) /
                                  3.2,
                              height: (MediaQuery.of(context).size.width - 45) /
                                  3.2,
                              child: Center(
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
        // SizedBox(
        //   height: 15,
        // ),
        // FlatButton(
        //   onPressed: () {
        //     Navigator.of(context).push(
        //       MaterialPageRoute(
        //         builder: (_) => RecordCameraPage(),
        //       ),
        //     );
        //   },
        //   child: Text("O, grabá un video"),
        // )
      ],
    );
  }
}
