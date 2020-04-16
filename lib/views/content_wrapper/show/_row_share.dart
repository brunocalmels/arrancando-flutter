import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/content_wrapper/dialog/share.dart';
import 'package:flutter/material.dart';

class RowShare extends StatelessWidget {
  final ContentWrapper content;

  RowShare({
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          onPressed: content == null
              ? null
              : () {
                  showDialog(
                    context: context,
                    builder: (_) => ShareContentWrapper(
                      content: content,
                    ),
                  );
                },
          icon: Icon(
            Icons.share,
            color: Theme.of(context).accentColor,
          ),
        ),
      ],
    );
  }
}
