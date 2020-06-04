import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/views/home/app_bar/_categories_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterBottomSheet extends StatelessWidget {
  final Function fetchContent;

  FilterBottomSheet({
    this.fetchContent,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<MainState, ContentPageState>(
      builder: (context, mainState, contentState, child) {
        return 
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 10),
        //   child:
           Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Seleccionar ${mainState.activePageHome == SectionType.publicaciones ? 'ciudad' : 'categoría'}: "),
                        ),
                        CategoriesChip(
                          fetchContent: fetchContent,
                          alignCenter: true,
                        ),
                        if (mainState.activePageHome ==
                            SectionType.publicaciones)
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Seleccionar categoría: "),
                            ),
                          ),
                        if (mainState.activePageHome ==
                            SectionType.publicaciones)
                          CategoriesChip(
                            fetchContent: fetchContent,
                            alignCenter: true,
                            pubCateg: mainState.activePageHome ==
                                SectionType.publicaciones,
                          ),
                        if (mainState.activePageHome == SectionType.pois)
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Seleccionar ciudad: "),
                            ),
                          ),
                        if (mainState.activePageHome == SectionType.pois)
                          CategoriesChip(
                            fetchContent: fetchContent,
                            alignCenter: true,
                            poiCity: true,
                          ),
                        Container(
                          padding: const EdgeInsets.only(top: 15),
                          width: MediaQuery.of(context).size.width / 1.8,
                          child: Theme(
                            data: ThemeData(
                              canvasColor: Theme.of(context).backgroundColor,
                            ),
                            child: DropdownButton<ContentSortType>(
                              isExpanded: true,
                              value: contentState.sortContentBy,
                              onChanged: (type) {
                                contentState.setContentSortType(type);
                                if (fetchContent != null) fetchContent();
                              },
                              items: <DropdownMenuItem<ContentSortType>>[
                                if (mainState.activePageHome !=
                                    SectionType.pois)
                                  DropdownMenuItem(
                                    value: ContentSortType.fecha,
                                    child: Text(
                                      "Fecha de creación",
                                      style: TextStyle(
                                        color: contentState.sortContentBy ==
                                                ContentSortType.fecha
                                            ? Theme.of(context).accentColor
                                            : Theme.of(context)
                                                .textTheme
                                                .body1
                                                .color
                                                .withAlpha(150),
                                      ),
                                    ),
                                  ),
                                if (mainState.activePageHome ==
                                    SectionType.pois)
                                  DropdownMenuItem(
                                    value: ContentSortType.proximidad,
                                    child: Text(
                                      "Proximidad",
                                      style: TextStyle(
                                        color: contentState.sortContentBy ==
                                                ContentSortType.proximidad
                                            ? Theme.of(context).accentColor
                                            : Theme.of(context)
                                                .textTheme
                                                .body1
                                                .color
                                                .withAlpha(150),
                                      ),
                                    ),
                                  ),
                                DropdownMenuItem(
                                  value: ContentSortType.puntuacion,
                                  child: Text(
                                    "Puntuación",
                                    style: TextStyle(
                                      color: contentState.sortContentBy ==
                                              ContentSortType.puntuacion
                                          ? Theme.of(context).accentColor
                                          : Theme.of(context)
                                              .textTheme
                                              .body1
                                              .color
                                              .withAlpha(150),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Mostrar solo míos"),
                              SizedBox(
                                width: 5,
                              ),
                              Switch(
                                activeColor: Theme.of(context).accentColor,
                                value: contentState
                                    .showMine[mainState.activePageHome],
                                onChanged: (val) async {
                                  await CategoryWrapper.saveShowMine(
                                    context,
                                    mainState.activePageHome,
                                    val,
                                  );
                                  if (fetchContent != null) fetchContent();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          // ),
        );
      },
    );
  }
}
