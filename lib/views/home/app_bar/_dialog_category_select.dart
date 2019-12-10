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
        content: Container(
          height: 200,
          child: ListView.builder(
            itemCount: widget.selectCity
                ? singleton.categories[SectionType.publicaciones].length
                : singleton
                    .categories[Provider.of<MyState>(context).activePageHome]
                    .length,
            itemBuilder: (BuildContext context, int index) {
              List<CategoryWrapper> _lista = widget.selectCity
                  ? singleton.categories[SectionType.publicaciones]
                  : singleton
                      .categories[Provider.of<MyState>(context).activePageHome];

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
