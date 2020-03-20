import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
              ),
            );
          },
          leading: Container(
            width: 40,
            child: poi.thumbnail == null
                ? Center(
                    child: Icon(
                      Icons.photo_camera,
                      color: Color(0x33000000),
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
                color: Colors.yellow,
                size: 14,
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                "${poi.puntajePromedio.toStringAsFixed(1)}",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              Text(
                " | ",
                style: TextStyle(
                  color: Colors.black12,
                ),
              ),
              Icon(
                Icons.location_on,
                color: Colors.black38,
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
                    color: Colors.black54,
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
