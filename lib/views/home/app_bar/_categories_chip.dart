import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:arrancando/views/home/app_bar/_dialog_category_select.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesChip extends StatefulWidget {
  final bool small;

  CategoriesChip({
    this.small = false,
  });

  @override
  _CategoriesChipState createState() => _CategoriesChipState();
}

class _CategoriesChipState extends State<CategoriesChip> {
  final GlobalSingleton singleton = GlobalSingleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        singleton.categories == null ||
                singleton.categories[
                        Provider.of<MyState>(context).activePageHome] ==
                    null ||
                singleton
                        .categories[
                            Provider.of<MyState>(context).activePageHome]
                        .length ==
                    0
            ? Container()
            : ChoiceChip(
                onSelected: (val) async {
                  int selected = await showDialog(
                    context: context,
                    builder: (_) => DialogCategorySelect(),
                  );
                  if (selected != null) {
                    Provider.of<MyState>(
                      context,
                      listen: false,
                    ).setSelectedCategoryHome(
                      Provider.of<MyState>(context).activePageHome,
                      selected,
                    );
                  }
                },
                label: Row(
                  children: <Widget>[
                    Icon(
                      MyGlobals.ICONOS_CATEGORIAS[
                          Provider.of<MyState>(context).activePageHome],
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
                        singleton.categories[Provider.of<MyState>(context).activePageHome]
                            .firstWhere((c) => Provider.of<MyState>(context)
                                            .selectedCategoryHome[
                                        Provider.of<MyState>(context)
                                            .activePageHome] !=
                                    null
                                ? c.id ==
                                    Provider.of<MyState>(context)
                                            .selectedCategoryHome[
                                        Provider.of<MyState>(context)
                                            .activePageHome]
                                : c.id ==
                                    Provider.of<MyState>(context)
                                        .preferredCategories[Provider.of<MyState>(context).activePageHome])
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
  }
}
