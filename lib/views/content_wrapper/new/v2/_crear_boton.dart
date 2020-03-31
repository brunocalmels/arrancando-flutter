import 'package:flutter/material.dart';

class NewContentCrearBoton extends StatelessWidget {
  final Function onPressed;
  final bool sent;

  NewContentCrearBoton({
    @required this.onPressed,
    @required this.sent,
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
                    "CREAR",
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
