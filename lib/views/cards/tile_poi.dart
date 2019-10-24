import 'package:arrancando/config/models/point_of_interest.dart';
import 'package:arrancando/config/my_globals.dart';
// import 'package:arrancando/config/my_globals.dart';
// import 'package:arrancando/views/cards/_row_puntajes.dart';
import 'package:flutter/material.dart';

class TilePoi extends StatelessWidget {
  final PointOfInterest poi;
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
        onPressed: () {},
        icon: Icon(
          Icons.arrow_forward,
        ),
      ),
    );
  }
}
