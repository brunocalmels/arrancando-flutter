import 'package:arrancando/views/home/app_bar/_dialog_category_select.dart';
import 'package:flutter/material.dart';

class CategoriesChip extends StatefulWidget {
  final int activeItem;
  final bool small;

  CategoriesChip({
    this.activeItem,
    this.small = false,
  });

  @override
  _CategoriesChipState createState() => _CategoriesChipState();
}

class _CategoriesChipState extends State<CategoriesChip> {
  Map<int, IconData> _icons = {
    0: Icons.select_all,
    1: Icons.public,
    2: Icons.book,
    3: Icons.map,
  };

  Map<int, String> _selected = {
    0: "Todos",
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
                _icons[widget.activeItem],
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
                  _selected[widget.activeItem],
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
