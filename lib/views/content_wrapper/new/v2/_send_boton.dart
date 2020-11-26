import 'package:flutter/material.dart';

class NewContentSendBoton extends StatelessWidget {
  final Function onPressed;
  final bool sent;
  final bool isEdit;

  NewContentSendBoton({
    @required this.onPressed,
    @required this.sent,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            color: Theme.of(context).backgroundColor,
            elevation: 10,
            child: sent
                ? SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    isEdit ? 'GUARDAR' : 'CREAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            onPressed: sent ? null : onPressed,
          ),
        ],
      ),
    );
  }
}
