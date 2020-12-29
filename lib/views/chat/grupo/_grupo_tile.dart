import 'package:arrancando/config/models/chat/grupo.dart';
import 'package:arrancando/views/chat/grupo/show/index.dart';
import 'package:flutter/material.dart';

class GrupoTile extends StatelessWidget {
  final GrupoChat grupo;

  const GrupoTile({
    Key key,
    @required this.grupo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: grupo.toColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            grupo.simbolo.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Text(grupo.nombre),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GrupoChatShowPage(
              grupo: grupo,
            ),
            settings: RouteSettings(
              name: 'GrupoChatShowPage#${grupo.id}',
            ),
          ),
        );
      },
    );
  }
}
