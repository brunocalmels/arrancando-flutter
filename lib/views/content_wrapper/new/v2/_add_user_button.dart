import 'package:arrancando/views/general/type_ahead_users.dart';
import 'package:flutter/material.dart';

class AddUserButton extends StatelessWidget {
  final TextEditingController controller;

  AddUserButton({
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.circle,
      color: Colors.transparent,
      child: Tooltip(
        message: 'Añadir link a usuario',
        child: IconButton(
          icon: Icon(
            Icons.person,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () async {
            final item = await showDialog(
              context: context,
              builder: (_) => TypeAheadUsers(),
            );

            if (item != null) {
              controller.text += '@${item.username}';
            }
          },
        ),
      ),
    );
  }
}
