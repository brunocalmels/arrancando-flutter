import 'dart:io';

import 'package:arrancando/config/globals/index.dart';
import 'package:flutter/material.dart';

class MuchoPesoArchivos extends StatelessWidget {
  final List<File> images;

  MuchoPesoArchivos({
    @required this.images,
  });

  @override
  Widget build(BuildContext context) {
    Future<int> _computeSize() async {
      int pesos = (await Future.wait(
        images.map(
          (i) => i.length(),
        ),
      ))
          .fold(
        0,
        (sum, i) => sum + i,
      );
      return pesos;
    }

    return FutureBuilder(
      future: _computeSize(),
      builder: (context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData &&
            snapshot.data >= MyGlobals.MUCHO_PESO_PUBLICACION)
          return Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              "Estás subiendo archivos muy pesados, el proceso puede tardar.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 13,
              ),
            ),
          );
        return Container();
      },
    );
  }
}
