import 'package:flutter/material.dart';

class RowPuntajes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: 20,
        ),
        SizedBox(
          width: 3,
        ),
        Text(
          "4.3",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          "(",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Text(
          "25",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Icon(
          Icons.person,
          color: Colors.white,
          size: 20,
        ),
        Text(
          ")",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
