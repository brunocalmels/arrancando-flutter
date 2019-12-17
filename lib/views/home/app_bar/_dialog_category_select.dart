import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogCategorySelect extends StatefulWidget {
  final bool selectCity;
  final bool allowDismiss;
  final String titleText;

  DialogCategorySelect({
    this.selectCity = false,
    this.allowDismiss = true,
    this.titleText = "Cambiar filtro",
  });

  @override
  _DialogCategorySelectState createState() => _DialogCategorySelectState();
}

class _DialogCategorySelectState extends State<DialogCategorySelect> {
  final GlobalSingleton singleton = GlobalSingleton();
  int _selected;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.allowDismiss ? true : _selected != null,
      child: AlertDialog(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        title: Text(widget.titleText),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.selectCity)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                child: Text(
                  "Si tu ciudad no aparece en el listado, seleccioná Neuquén y contactate con nosotros a través de la sección de perfil para que la agregemos.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              ),
            Container(
              height: 220,
              child: ListView.builder(
                itemCount: widget.selectCity
                    ? singleton.categories[SectionType.publicaciones].length - 1
                    : singleton
                        .categories[
                            Provider.of<MyState>(context).activePageHome]
                        .length,
                itemBuilder: (BuildContext context, int index) {
                  List<CategoryWrapper> _lista = widget.selectCity
                      ? [...singleton.categories[SectionType.publicaciones]]
                      : [
                          ...singleton.categories[
                              Provider.of<MyState>(context).activePageHome]
                        ];

                  if (widget.selectCity) _lista.removeWhere((c) => c.id == -1);

                  return ListTile(
                    onTap: () {
                      _selected = _lista[index].id;
                      if (mounted) setState(() {});
                      Navigator.of(context).pop(_lista[index].id);
                    },
                    leading: Icon(Icons.location_on),
                    title: Text(_lista[index].nombre),
                  );
                },
              ),
            ),
          ],
        ),
        actions: <Widget>[
          if (widget.allowDismiss)
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
        ],
      ),
    );
  }
}
