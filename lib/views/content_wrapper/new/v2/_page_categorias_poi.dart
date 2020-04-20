import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:flutter/material.dart';

class PageCategoriasPoi extends StatefulWidget {
  final CategoryWrapper categoria;

  PageCategoriasPoi({
    this.categoria,
  });

  @override
  _PageCategoriasStatePoi createState() => _PageCategoriasStatePoi();
}

class _PageCategoriasStatePoi extends State<PageCategoriasPoi> {
  CategoryWrapper _categoria;
  final GlobalSingleton gs = GlobalSingleton();

  @override
  void initState() {
    super.initState();
    _categoria = widget.categoria;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SELECCIONAR CATEGORÍA",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...gs.categories[SectionType.pois]
                .where((c) => c.id > 0)
                .map(
                  (c) => RadioListTile(
                    groupValue: _categoria != null ? _categoria.id : null,
                    title: Text(c.nombre),
                    value: c.id,
                    onChanged: (val) {
                      _categoria = c;
                      if (mounted) setState(() {});
                    },
                  ),
                )
                .toList(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Theme.of(context).backgroundColor,
                    elevation: 10,
                    child: Text(
                      "LISTO",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(_categoria);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
