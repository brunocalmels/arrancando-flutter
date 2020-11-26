import 'package:flutter/material.dart';

class PermissionDeniedDialog extends StatelessWidget {
  final String mensaje;

  PermissionDeniedDialog({
    @required this.mensaje,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Permiso denegado'),
      content: Text(
        mensaje,
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Aceptar'),
        )
      ],
    );
  }
}
