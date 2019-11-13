import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogCategorySelect extends StatelessWidget {
  final GlobalSingleton singleton = GlobalSingleton();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      title: Text('Cambiar filtro'),
      content: Container(
        height: 200,
        child: ListView.builder(
          itemCount: singleton
              .categories[Provider.of<MyState>(context).activePageHome].length,
          itemBuilder: (BuildContext context, int index) {
            List<CategoryWrapper> _lista = singleton
                .categories[Provider.of<MyState>(context).activePageHome];

            return ListTile(
              onTap: () {
                Navigator.of(context).pop(_lista[index].id);
              },
              leading: Icon(Icons.location_on),
              title: Text(_lista[index].nombre),
            );
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
      ],
    );
  }
}
