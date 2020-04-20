import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:flutter/material.dart';

class RowIconosFecha extends StatelessWidget {
  final ContentWrapper content;

  RowIconosFecha({
    @required this.content,
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
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  Icons.favorite,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            if (content.type != SectionType.pois)
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
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
            if (content.type != SectionType.pois)
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            GestureDetector(
              onTap: () => SavedContent.toggleSave(content, context),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  SavedContent.isSaved(content, context)
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
