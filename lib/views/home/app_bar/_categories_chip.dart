import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_page_categorias.dart';
import 'package:arrancando/views/home/app_bar/_dialog_category_select.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesChip extends StatefulWidget {
  final Function fetchContent;
  final bool small;
  final bool alignCenter;
  final bool pubCateg;
  final bool poiCity;

  CategoriesChip({
    this.fetchContent,
    this.small = false,
    this.alignCenter = false,
    this.pubCateg = false,
    this.poiCity = false,
  });

  @override
  _CategoriesChipState createState() => _CategoriesChipState();
}

class _CategoriesChipState extends State<CategoriesChip> {
  final GlobalSingleton singleton = GlobalSingleton();

  @override
  Widget build(BuildContext context) {
    return Consumer2<MainState, UserState>(
      builder: (context, mainState, userState, child) {
        return Row(
          mainAxisAlignment: widget.alignCenter
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            singleton.categories == null ||
                    singleton.categories[mainState.activePageHome] == null ||
                    singleton.categories[mainState.activePageHome].isEmpty
                ? Container()
                : ChoiceChip(
                    onSelected: (val) async {
                      print(mainState.activePageHome == SectionType.recetas);
                      final selected = await showDialog(
                        context: context,
                        builder: (_) =>
                            mainState.activePageHome == SectionType.recetas
                                ? PageCategorias(
                                    returnOnlyId: true,
                                    showTodas: true,
                                  )
                                : DialogCategorySelect(
                                    selectCity:
                                        mainState.activePageHome != null &&
                                            mainState.activePageHome ==
                                                SectionType.publicaciones,
                                    pubCateg: widget.pubCateg,
                                    poiCity: widget.poiCity,
                                  ),
                      );
                      if (selected != null) {
                        mainState.setSelectedCategoryHome(
                          widget.pubCateg
                              ? SectionType.publicaciones_categoria
                              : widget.poiCity
                                  ? SectionType.pois_ciudad
                                  : mainState.activePageHome,
                          selected,
                        );
                        if (widget.fetchContent != null) widget.fetchContent();
                      }
                    },
                    label: Row(
                      children: <Widget>[
                        // Icon(
                        //   MyGlobals.ICONOS_CATEGORIAS[mainState.activePageHome],
                        //   size: widget.small ? 12 : 15,
                        // ),
                        // SizedBox(
                        //   width: 5,
                        // ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: widget.small ? 20 : 150,
                          ),
                          child: Builder(
                            builder: (context) {
                              final category =
                                  singleton.categories[widget.pubCateg
                                          ? SectionType.publicaciones_categoria
                                          : widget.poiCity
                                              ? SectionType.pois_ciudad
                                              : mainState.activePageHome]
                                      .firstWhere(
                                (c) => mainState.selectedCategoryHome[widget
                                                .pubCateg
                                            ? SectionType
                                                .publicaciones_categoria
                                            : widget.poiCity
                                                ? SectionType.pois_ciudad
                                                : mainState.activePageHome] !=
                                        null
                                    ? c.id ==
                                        mainState.selectedCategoryHome[
                                            widget.pubCateg
                                                ? SectionType
                                                    .publicaciones_categoria
                                                : widget.poiCity
                                                    ? SectionType.pois_ciudad
                                                    : mainState.activePageHome]
                                    : c.id ==
                                        userState.preferredCategories[
                                            widget.pubCateg
                                                ? SectionType
                                                    .publicaciones_categoria
                                                : widget.poiCity
                                                    ? SectionType.pois_ciudad
                                                    : mainState.activePageHome],
                                orElse: () => null,
                              );

                              return Text(
                                category?.nombre ?? 'Seleccionar',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: widget.small ? 10 : 14,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    selected: false,
                  ),
          ],
        );
      },
    );
  }
}
