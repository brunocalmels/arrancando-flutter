import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/services/utils.dart';
import 'package:flutter/material.dart';

class PageCategorias extends StatelessWidget {
  final GlobalSingleton gs = GlobalSingleton();
  final bool returnOnlyId;
  final bool showTodas;

  PageCategorias({
    this.returnOnlyId = false,
    this.showTodas = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SELECCIONAR CATEGORÍA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      body: gs.categories[SectionType.recetas]
              .where((c) => c.version == 2)
              .isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: (showTodas
                        ? [
                            CategoryWrapper(
                              id: -1,
                              nombre: 'Todos',
                            ),
                            ...gs.categories[SectionType.recetas]
                                .where((c) => c.version == 2),
                          ]
                        : gs.categories[SectionType.recetas]
                            .where((c) => c.version == 2))
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
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: MyGlobals.IMAGENES_CATEGORIAS_RECETAS[
                                            c.nombre] !=
                                        null
                                    ? Image.asset(
                                        MyGlobals.IMAGENES_CATEGORIAS_RECETAS[
                                            c.nombre],
                                        fit: BoxFit.fitHeight,
                                      )
                                    : Container(),
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
                                    colors: Utils.activeTheme(context) ==
                                            ThemeMode.light
                                        ? [Color(0xffcccccc), Color(0xffeeeeee)]
                                        : [
                                            Color(0xff232937),
                                            Color(0xff1c2333),
                                          ],
                                  ),
                                ),
                                height: 50,
                                child: Center(
                                  child: Text(c.nombre),
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
                                  if (returnOnlyId) {
                                    Navigator.of(context).pop(c.id);
                                  } else {
                                    Navigator.of(context).pop(c);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Ocurrió un error',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
    );
  }
}
