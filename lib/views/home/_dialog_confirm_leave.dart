import 'package:flutter/material.dart';

class DialogConfirmLeave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Salir',
      ),
      content: Text(
        '¿Estás seguro que querés salir?',
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancelar',
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(
            'Salir',
          ),
        ),
      ],
    );
  }
}
