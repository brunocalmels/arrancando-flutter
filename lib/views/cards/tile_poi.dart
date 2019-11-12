import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:flutter/material.dart';

class TilePoi extends StatelessWidget {
  final ContentWrapper poi;
  final Function onTap;

  TilePoi({
    this.poi,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        child: Image.network(
          "${MyGlobals.SERVER_URL}${poi.imagenes.first}",
          fit: BoxFit.cover,
        ),
      ),
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              poi.titulo,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: 14,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            "4.3",
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
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
          Text(
            "3.5km",
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
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
    );
  }
}
