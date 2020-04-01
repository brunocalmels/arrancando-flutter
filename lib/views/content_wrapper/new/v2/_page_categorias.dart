import 'package:arrancando/config/globals/index.dart';
import 'package:flutter/material.dart';

class PageCategorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SELECCIONAR CATEGORÍA",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: MyGlobals.CATEGORIAS_RECETA
              .map(
                (c) => Stack(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Image.asset(
                            c['imagen'],
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Colors.black38,
                                offset: Offset(0, 2),
                              )
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xff232937),
                                Color(0xff1c2333),
                              ],
                            ),
                          ),
                          height: 50,
                          child: Center(
                            child: Text(c['titulo']),
                          ),
                        ),
                      ],
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        type: MaterialType.card,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop(c);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
