import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/views/content_wrapper/new/v2/poi.dart';
import 'package:arrancando/views/content_wrapper/new/v2/publicacion.dart';
import 'package:arrancando/views/content_wrapper/new/v2/receta.dart';
import 'package:arrancando/views/general/curved_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeFab extends StatelessWidget {
  final Map<SectionType, IconData> sectionTypeIconMapper = {
    SectionType.home: Icons.public,
    SectionType.publicaciones: Icons.public,
    SectionType.recetas: Icons.fastfood,
    SectionType.pois: Icons.location_on,
    SectionType.wiki: Icons.library_books,
  };

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Positioned.fill(
          child: CurvedText(
            radius: 30,
            text: "NUEVO",
            textStyle: TextStyle(),
            startAngle: 5.5,
          ),
        ),
        FloatingActionButton(
          elevation: 10,
          backgroundColor: Theme.of(context).backgroundColor,
          onPressed: () {
            Widget page;

            switch (Provider.of<MainState>(context).activePageHome) {
              case SectionType.home:
                page = PublicacionForm();
                break;
              case SectionType.recetas:
                page = RecetaForm();
                break;
              case SectionType.pois:
                page = PoiForm();
                break;
              default:
                page = PublicacionForm();
            }
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => page,
              ),
            );
          },
          child: Container(
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  right: -22,
                  top: -22,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                Positioned.fill(
                  child: Icon(
                    sectionTypeIconMapper[
                        Provider.of<MainState>(context).activePageHome],
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
