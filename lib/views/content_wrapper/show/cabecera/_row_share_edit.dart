import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/content_wrapper/dialog/share.dart';
import 'package:arrancando/views/content_wrapper/edit/index.dart';
import 'package:arrancando/views/content_wrapper/new/v2/poi.dart';
import 'package:arrancando/views/content_wrapper/new/v2/publicacion.dart';
import 'package:arrancando/views/content_wrapper/new/v2/receta.dart';
import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:url_launcher/url_launcher.dart';

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (content.vistas != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Text(
                  '${content.vistas}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.remove_red_eye,
                  size: 20,
                  color: Theme.of(context).accentColor,
                ),
              ],
            )
          else
            Container(),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  icon: IconShadowWidget(
                    Icon(
                      Icons.edit,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              if (content != null && content.type == SectionType.pois)
                SizedBox(
                  width: 35,
                  child: GestureDetector(
                    onTap: () async {
                      final url =
                          'http://maps.google.com/maps?z=15&t=m&q=loc:${content.latitud}+${content.longitud}';
                      if (await canLaunch(url)) {
                        await launch(
                          url,
                          forceSafariVC: false,
                          forceWebView: false,
                        );
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    // child: Image.asset(
                    //   'assets/images/logo-google.png',
                    //   width: 20,
                    //   height: 20,
                    // ),
                    child: ImageIcon(
                      AssetImage(
                        'assets/images/logo-google.png',
                      ),
                      size: 20,
                      color: Theme.of(context).accentColor,
                    ),
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
                icon: IconShadowWidget(
                  Icon(
                    Icons.share,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
