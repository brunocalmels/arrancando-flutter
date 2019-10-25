import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogCategorySelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      title: Text('Cambiar filtro'),
      content: Container(
        height: 150,
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            List<String> _lista = MyGlobals
                .TIPOS_CATEGORIAS[Provider.of<MyState>(context).activePageHome];

            return ListTile(
              onTap: () {
                Navigator.of(context).pop(_lista[index]);
              },
              leading: Icon(Icons.location_on),
              title: Text(_lista[index]),
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
