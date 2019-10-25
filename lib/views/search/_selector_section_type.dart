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
        VerticalDivider(),
        DropdownButton(
          onChanged: setActiveType,
          value: activeType,
          items: SectionType.values
              .sublist(1)
              .map(
                (v) => DropdownMenuItem(
                  value: v,
                  child: Icon(MyGlobals.ICONOS_CATEGORIAS[v]),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
