import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogContenidosHome extends StatefulWidget {
  @override
  _DialogContenidosHomeState createState() => _DialogContenidosHomeState();
}

class _DialogContenidosHomeState extends State<DialogContenidosHome> {
  final List _items = [
    // {
    //   "type": SectionType.publicaciones,
    //   "text": "Comunidad",
    //   "icon": Icons.home,
    // },
    {
      "type": SectionType.publicaciones,
      "text": "Publicaciones",
      "icon": Icons.home,
    },
    {
      "type": SectionType.recetas,
      "text": "Recetas",
      "icon": Icons.fastfood,
    },
    {
      "type": SectionType.pois,
      "text": "P. Interés",
      "icon": Icons.location_on,
    },
    // {
    //   "type": SectionType.wiki,
    //   "text": "Wiki",
    //   "icon": Icons.library_books,
    // },
  ];

  List<SectionType> _contenidos = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _contenidos = [...Provider.of<MainState>(context).contenidosHome];
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      title: Container(
        padding: const EdgeInsets.all(15),
        color: Theme.of(context).backgroundColor,
        child: Text(
          "ELIGE EL TIPO DE CONTENIDO QUE DESEAS VER",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: _items
            .map(
              (i) => CheckboxListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          i['text'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(i['icon']),
                    ],
                  ),
                ),
                value: _contenidos.contains(i['type']),
                onChanged: (val) {
                  if (val) {
                    _contenidos.add(i['type']);
                  } else {
                    _contenidos.remove(i['type']);
                  }
                  if (mounted) setState(() {});
                },
              ),
            )
            .toList(),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("CANCELAR"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text("ACEPTAR"),
          onPressed: () => Navigator.of(context).pop(_contenidos),
        ),
      ],
    );
  }
}
