import 'package:arrancando/home/app_bar/_dialog_category_select.dart';
import 'package:flutter/material.dart';

class CategoriesChip extends StatefulWidget {
  final int activeItem;

  CategoriesChip({
    this.activeItem,
  });

  @override
  _CategoriesChipState createState() => _CategoriesChipState();
}

class _CategoriesChipState extends State<CategoriesChip> {
  Map<int, String> _selected = {
    1: "Neuquén",
    2: "Con carne",
    3: "Carne",
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ChoiceChip(
          onSelected: (val) async {
            String res = await showDialog(
              context: context,
              builder: (_) => DialogCategorySelect(
                activeItem: widget.activeItem,
              ),
            );
            if (res != null) {
              setState(() {
                _selected[widget.activeItem] = res;
              });
            }
          },
          label: Row(
            children: <Widget>[
              Icon(
                Icons.location_on,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: 150,
                ),
                child: Text(
                  _selected[widget.activeItem],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
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
