import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/content_wrapper/show/_heart_plus5.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RowIconosFecha extends StatelessWidget {
  final ContentWrapper content;
  final Function fetchContent;

  RowIconosFecha({
    @required this.content,
    this.fetchContent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeartPlus5(
              content: content,
              fetchContent: fetchContent,
            ),
            // if (content.type != SectionType.pois)
            //   GestureDetector(
            //     child: Padding(
            //       padding: const EdgeInsets.all(5),
            //       child: Icon(
            //         Icons.chat_bubble_outline,
            //         color: Theme.of(context).accentColor,
            //       ),
            //     ),
            //   ),
          ],
        ),
        Text(
          content.fechaTexto.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white.withAlpha(150),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // if (content.type != SectionType.pois)
            //   GestureDetector(
            //     child: Padding(
            //       padding: const EdgeInsets.all(5),
            //       child: Icon(
            //         Icons.camera_alt,
            //         color: Theme.of(context).accentColor,
            //       ),
            //     ),
            //   ),
            GestureDetector(
              onTap: () => SavedContent.toggleSave(content, context),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  context.watch<UserState>().savedContent.any(
                            (sc) =>
                                sc.id == content.id && sc.type == content.type,
                          )
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
