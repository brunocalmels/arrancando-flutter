import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:flutter/material.dart';

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
          onTap: onTap,
          leading: Container(
            width: 40,
            child: poi.imagenes.length == 0
                ? Center(
                    child: Icon(
                      Icons.photo_camera,
                      color: Color(0x33000000),
                    ),
                  )
                : Image.network(
                    "${MyGlobals.SERVER_URL}${poi.imagenes.first}",
                    fit: BoxFit.cover,
                  ),
          ),
          title: Text(
            poi.titulo,
            overflow: TextOverflow.ellipsis,
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
                "${poi.puntajePromedio}",
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
              if (!locationDenied)
                FutureBuilder(
                  future: poi.distancia,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Text(
                        "${snapshot.data}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      );
                    }
                    return Container();
                  },
                ),
            ],
          ),
          trailing: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShowPage(
                    contentId: poi.id,
                    type: SectionType.pois,
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.arrow_forward,
            ),
          ),
        ),
        Divider(
          height: 2,
        ),
      ],
    );
  }
}
