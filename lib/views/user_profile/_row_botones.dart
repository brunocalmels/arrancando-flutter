import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/services/utils.dart';
import 'package:flutter/material.dart';

class RowBotonesUserProfile extends StatelessWidget {
  final SectionType activeSection;
  final Function(SectionType) setActiveSection;
  final Map<SectionType, int> count;

  RowBotonesUserProfile({
    @required this.activeSection,
    @required this.setActiveSection,
    @required this.count,
  });

  Widget _buildButton(
    BuildContext context,
    int numero,
    String texto,
    SectionType type,
  ) =>
      Expanded(
        child: FlatButton(
          onPressed: () {
            setActiveSection(type);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Opacity(
              opacity: activeSection == type ? 1 : 0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$numero',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Utils.activeTheme(context) == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '$texto',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildButton(
            context,
            count[SectionType.publicaciones],
            'PUBLICACIONES',
            SectionType.publicaciones,
          ),
          _buildButton(
            context,
            count[SectionType.recetas],
            'RECETAS',
            SectionType.recetas,
          ),
          _buildButton(
            context,
            count[SectionType.pois],
            'TIENDAS',
            SectionType.pois,
          ),
          // _buildButton(
          //   9,
          //   'WIKI',
          //   SectionType.wiki,
          // ),
        ],
      ),
    );
  }
}
