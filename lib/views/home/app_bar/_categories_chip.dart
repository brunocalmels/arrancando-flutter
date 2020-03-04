import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/home/app_bar/_dialog_category_select.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesChip extends StatefulWidget {
  final Function fetchContent;
  final bool small;

  CategoriesChip({
    this.fetchContent,
    this.small = false,
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            singleton.categories == null ||
                    singleton.categories[mainState.activePageHome] == null ||
                    singleton.categories[mainState.activePageHome].length == 0
                ? Container()
                : ChoiceChip(
                    onSelected: (val) async {
                      int selected = await showDialog(
                        context: context,
                        builder: (_) => DialogCategorySelect(
                          selectCity: mainState.activePageHome != null &&
                              mainState.activePageHome ==
                                  SectionType.publicaciones,
                        ),
                      );
                      if (selected != null) {
                        Provider.of<MainState>(
                          context,
                          listen: false,
                        ).setSelectedCategoryHome(
                          mainState.activePageHome,
                          selected,
                        );
                        if (widget.fetchContent != null) widget.fetchContent();
                      }
                    },
                    label: Row(
                      children: <Widget>[
                        Icon(
                          MyGlobals.ICONOS_CATEGORIAS[mainState.activePageHome],
                          size: widget.small ? 12 : 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: widget.small ? 20 : 150,
                          ),
                          child: Text(
                            singleton.categories[mainState.activePageHome]
                                .firstWhere((c) =>
                                    mainState.selectedCategoryHome[
                                                mainState.activePageHome] !=
                                            null
                                        ? c.id ==
                                            mainState.selectedCategoryHome[
                                                mainState.activePageHome]
                                        : c.id ==
                                            userState.preferredCategories[
                                                mainState.activePageHome])
                                .nombre,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: widget.small ? 10 : 14,
                            ),
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
