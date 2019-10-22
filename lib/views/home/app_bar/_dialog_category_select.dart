import 'package:flutter/material.dart';

class DialogCategorySelect extends StatelessWidget {
  final int activeItem;

  DialogCategorySelect({
    this.activeItem,
  });

  final List<String> _ciudades = [
    'Neuquén',
    'Cipolletti',
    'Plottier',
  ];
  final List<String> _categorias = [
    'Con carne',
    'Sin carne',
    'Sin comida',
  ];
  final List<String> _rubros = [
    'Carne',
    'Leña',
    'Artesanos del hierro (keeeh???)',
  ];

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
            List<String> _lista = _ciudades;
            switch (activeItem) {
              case 1:
                _lista = _ciudades;
                break;
              case 2:
                _lista = _categorias;
                break;
              case 3:
                _lista = _rubros;
                break;
              default:
                _lista = _ciudades;
            }

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
