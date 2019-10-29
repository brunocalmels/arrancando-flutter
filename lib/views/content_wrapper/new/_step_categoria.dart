import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:flutter/material.dart';

class StepCategoria extends StatelessWidget {
  final SectionType type;
  final CategoryWrapper selectedCategory;
  final Function setCategory;
  final GlobalSingleton singleton = GlobalSingleton();

  StepCategoria({
    @required this.type,
    @required this.selectedCategory,
    @required this.setCategory,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: singleton.categories[type]
              .map(
                (t) => RadioListTile<CategoryWrapper>(
                  title: Text(t.nombre),
                  groupValue: selectedCategory,
                  value: t,
                  onChanged: setCategory,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
