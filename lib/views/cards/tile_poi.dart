import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TilePoi extends StatelessWidget {
  final ContentWrapper poi;
  final Function onTap;
  final bool locationDenied;

  TilePoi({
    this.poi,
    this.onTap,
    this.locationDenied,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ShowPage(
                  contentId: poi.id,
                  type: SectionType.pois,
                ),
                settings: RouteSettings(name: 'Pois#${poi.id}'),
              ),
            );
          },
          leading: Container(
            width: 40,
            child: poi.thumbnail == null
                ? Center(
                    child: Icon(
                      Icons.photo_camera,
                      color: Provider.of<MainState>(context).activeTheme ==
                              ThemeMode.dark
                          ? Colors.white38
                          : Colors.black38,
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: "${MyGlobals.SERVER_URL}${poi.thumbnail}",
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
          ),
          title: Text(
            poi.titulo,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
            ),
          ),
          subtitle: Row(
            children: <Widget>[
              Icon(
                Icons.star,
                color: Theme.of(context).accentColor,
                size: 14,
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                "${poi.puntajePromedio.toStringAsFixed(1)}",
                style: TextStyle(
                    fontSize: 13,
                    color: Provider.of<MainState>(context).activeTheme ==
                            ThemeMode.dark
                        ? Colors.white
                        : Colors.black),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.location_on,
                color: Theme.of(context).accentColor,
                size: 14,
              ),
              SizedBox(
                width: 3,
              ),
              if (poi.localDistance != null)
                Text(
                  poi.localDistance != null ? poi.distanciaToH() : '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Provider.of<MainState>(context).activeTheme ==
                            ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 35,
                child: GestureDetector(
                  onTap: () async {
                    String url =
                        "http://maps.google.com/maps?z=15&t=m&q=loc:${poi.latitud}+${poi.longitud}";
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
                  child: Image.asset(
                    "assets/images/logo-google.png",
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              SizedBox(
                width: 35,
                child: IconButton(
                  onPressed: () => SavedContent.toggleSave(poi, context),
                  color: Theme.of(context).accentColor,
                  icon: Icon(
                    SavedContent.isSaved(poi, context)
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                  ),
                ),
              ),
              SizedBox(
                width: 35,
                child: IconButton(
                  onPressed: onTap,
                  color: Theme.of(context).accentColor,
                  icon: Icon(
                    Icons.location_on,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 2,
        ),
      ],
    );
  }
}
