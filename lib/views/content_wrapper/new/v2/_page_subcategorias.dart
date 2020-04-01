import 'package:arrancando/config/globals/index.dart';
import 'package:flutter/material.dart';

class PageSubCategorias extends StatefulWidget {
  final List<dynamic> selectedCategorias;

  PageSubCategorias({
    this.selectedCategorias,
  });

  @override
  _PageSubCategoriasState createState() => _PageSubCategoriasState();
}

class _PageSubCategoriasState extends State<PageSubCategorias> {
  List<dynamic> _selectedSubcategorias = [];

  @override
  void initState() {
    super.initState();
    _selectedSubcategorias = widget.selectedCategorias ?? [];
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SELECCIONAR SUBCATEGORÍAS",
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
            ...MyGlobals.SUBCATEGORIAS_RECETA
                .map(
                  (c) => CheckboxListTile(
                    title: Text(c['titulo']),
                    value: _selectedSubcategorias.contains(c),
                    onChanged: (val) {
                      if (val)
                        _selectedSubcategorias.add(c);
                      else
                        _selectedSubcategorias.remove(c);
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
                      Navigator.of(context).pop(_selectedSubcategorias);
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
