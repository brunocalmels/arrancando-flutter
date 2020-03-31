import 'package:flutter/material.dart';

class NewContentErrorMessage extends StatelessWidget {
  final String message;

  NewContentErrorMessage({
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return message != null && message.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                message,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          )
        : Container();
  }
}
