import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/content_wrapper/edit/index.dart';
import 'package:arrancando/views/content_wrapper/new/v2/publicacion.dart';
import 'package:flutter/material.dart';

class ShowAppBar extends StatelessWidget {
  final ContentWrapper content;
  final Function fetchContent;

  ShowAppBar({
    @required this.content,
    @required this.fetchContent,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // elevation: 0,
      // backgroundColor: Colors.transparent,
      // iconTheme: IconThemeData(
      //   color: Colors.black,
      // ),
      actions: <Widget>[
        // if (content != null &&
        //     widget.type == SectionType.pois &&
        //     content.latitud != null &&
        //     content.longitud != null)
        //   SizedBox(
        //     width: 50,
        //     child: GestureDetector(
        //       onTap: () async {
        //         String url =
        //             "http://maps.google.com/maps?z=15&t=m&q=loc:${content.latitud}+${content.longitud}";
        //         if (await canLaunch(url)) {
        //           await launch(
        //             url,
        //             forceSafariVC: false,
        //             forceWebView: false,
        //           );
        //         } else {
        //           throw 'Could not launch $url';
        //         }
        //       },
        //       child: Center(
        //         child: Image.asset(
        //           "assets/images/logo-google.png",
        //           width: 25,
        //           height: 25,
        //         ),
        //       ),
        //     ),
        //   ),
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
            icon: Icon(Icons.edit),
          ),
        // if (content != null)
        //   IconButton(
        //     onPressed: () => SavedContent.toggleSave(content, context),
        //     icon: Icon(
        //       SavedContent.isSaved(content, context)
        //           ? Icons.bookmark
        //           : Icons.bookmark_border,
        //     ),
        //   ),
        // IconButton(
        //   onPressed: content == null
        //       ? null
        //       : () {
        //           showDialog(
        //             context: context,
        //             builder: (_) => ShareContentWrapper(
        //               content: content,
        //             ),
        //           );
        //         },
        //   icon: Icon(Icons.share),
        // ),
      ],
    );
  }
}
