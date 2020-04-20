import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:flutter/material.dart';

class SelectorSectionType extends StatelessWidget {
  final SectionType activeType;
  final Function(SectionType) setActiveType;

  SelectorSectionType({
    this.activeType,
    this.setActiveType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(
            canvasColor: Theme.of(context).backgroundColor,
          ),
          child: DropdownButton(
            onChanged: setActiveType,
            value: activeType,
            isDense: true,
            items: [
              SectionType.publicaciones,
              SectionType.recetas,
              SectionType.pois
            ]
                .map(
                  (v) => DropdownMenuItem(
                    value: v,
                    child: Icon(
                      MyGlobals.ICONOS_CATEGORIAS[v],
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
