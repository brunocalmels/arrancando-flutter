import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/content_wrapper/dialog/share.dart';
import 'package:arrancando/views/content_wrapper/edit/index.dart';
import 'package:arrancando/views/content_wrapper/new/v2/poi.dart';
import 'package:arrancando/views/content_wrapper/new/v2/publicacion.dart';
import 'package:arrancando/views/content_wrapper/new/v2/receta.dart';
import 'package:flutter/material.dart';

class RowShareEdit extends StatelessWidget {
  final ContentWrapper content;
  final Function fetchContent;

  RowShareEdit({
    @required this.content,
    @required this.fetchContent,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (content != null && content.esOwner(context))
            IconButton(
              onPressed: () async {
                Widget page;

                switch (content.type) {
                  case SectionType.publicaciones:
                    page = PublicacionForm(
                      content: content,
                    );
                    break;
                  case SectionType.recetas:
                    page = RecetaForm(
                      content: content,
                    );
                    break;
                  case SectionType.pois:
                    page = PoiForm(
                      content: content,
                    );
                    break;
                  default:
                    page = EditPage(
                      contentId: content.id,
                      type: content.type,
                    );
                }

                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => page,
                    settings: RouteSettings(
                      name:
                          '${content.type.toString().split('.').last[0].toLowerCase()}${content.type.toString().split('.').last.substring(1)}#${content.id}#Edit',
                    ),
                  ),
                );
                await Future.delayed(Duration(seconds: 1));
                fetchContent();
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).accentColor,
              ),
            ),
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
      ),
    );
  }
}
