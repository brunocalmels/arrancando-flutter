import 'package:arrancando/config/services/utils.dart';
import 'package:arrancando/views/user_profile/_dialog_seguidos_seguidores.dart';
import 'package:flutter/material.dart';

class RowSeguidosSeguidores extends StatelessWidget {
  final int userId;
  final int seguidos;
  final int seguidores;

  RowSeguidosSeguidores({
    @required this.userId,
    @required this.seguidos,
    @required this.seguidores,
  });

  Widget _buildButton(
    int numero,
    String texto,
    BuildContext context,
  ) =>
      Expanded(
        child: RaisedButton(
          onPressed: numero > 0
              ? () {
                  showDialog(
                    context: context,
                    builder: (_) => DialogSeguidosSeguidores(
                      userId: userId,
                      isSeguidores: texto.toLowerCase().contains('seguidor'),
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$numero',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: numero > 0
                        ? Utils.activeTheme(context) == ThemeMode.dark
                            ? Theme.of(context).primaryColor
                            : Colors.black87
                        : Colors.white30,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '$texto',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: numero > 0
                        ? Utils.activeTheme(context) == ThemeMode.dark
                            ? Theme.of(context).primaryColor
                            : Colors.black87
                        : Colors.white30,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildButton(
            seguidos,
            seguidos == 1 ? 'SEGUIDO' : 'SEGUIDOS',
            context,
          ),
          SizedBox(width: 3),
          _buildButton(
            seguidores,
            seguidores == 1 ? 'SEGUIDOR' : 'SEGUIDORES',
            context,
          ),
        ],
      ),
    );
  }
}
