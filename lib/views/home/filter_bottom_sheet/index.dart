import 'dart:io';

import 'package:arrancando/config/globals/enums.dart';
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
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: Colors.black,
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            minHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                child: Container(
                  width: 20,
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height * 0.41,
                  minHeight: MediaQuery.of(context).size.height * 0.21,
                ),
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
                      if (mainState.activePageHome == SectionType.publicaciones)
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Seleccionar categoría: "),
                          ),
                        ),
                      if (mainState.activePageHome == SectionType.publicaciones)
                        CategoriesChip(
                          fetchContent: fetchContent,
                          alignCenter: true,
                          pubCateg: mainState.activePageHome ==
                              SectionType.publicaciones,
                        ),
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: DropdownButton<ContentSortType>(
                          isExpanded: true,
                          value: contentState.sortContentBy,
                          onChanged: (type) {
                            contentState.setContentSortType(type);
                            if (fetchContent != null) fetchContent();
                          },
                          items: <DropdownMenuItem<ContentSortType>>[
                            if (mainState.activePageHome != SectionType.pois)
                              DropdownMenuItem(
                                value: ContentSortType.fecha,
                                child: Text(
                                  "Fecha",
                                  style: TextStyle(
                                      color: contentState.sortContentBy ==
                                              ContentSortType.fecha
                                          ? Theme.of(context).accentColor
                                          : null),
                                ),
                              ),
                            if (mainState.activePageHome == SectionType.pois)
                              DropdownMenuItem(
                                value: ContentSortType.proximidad,
                                child: Text(
                                  "Proximidad",
                                  style: TextStyle(
                                      color: contentState.sortContentBy ==
                                              ContentSortType.proximidad
                                          ? Theme.of(context).accentColor
                                          : null),
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
                                        : null),
                              ),
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
        );
      },
    );
  }
}
