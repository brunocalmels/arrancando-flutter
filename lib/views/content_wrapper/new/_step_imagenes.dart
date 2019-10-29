import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class StepImagenes extends StatefulWidget {
  final List<Asset> images;
  final Function setImages;

  StepImagenes({
    @required this.images,
    @required this.setImages,
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: widget.images.length == 0
          ? Center(
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
            )
          : GridView.count(
              crossAxisCount: 3,
              children: List.generate(
                widget.images.length,
                (index) {
                  Asset asset = widget.images[index];
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: AssetThumb(
                      asset: asset,
                      width: 300,
                      height: 300,
                      spinner: Center(
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
