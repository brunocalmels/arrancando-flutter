import 'package:arrancando/views/home/app_bar/_categories_chip.dart';
import 'package:arrancando/views/home/app_bar/_dialog_category_select.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final int activeItem;
  final Function(bool) setSent;
  final Function showSearchPage;
  final TextEditingController searchController;

  SearchBar({
    this.activeItem,
    this.setSent,
    this.showSearchPage,
    this.searchController,
  });

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              onChanged: (val) async {
                if (val != null && val.isNotEmpty) {
                  widget.setSent(true);
                  widget.showSearchPage(true);
                  await Future.delayed(Duration(seconds: 3));
                  widget.setSent(false);
                }
              },
              autofocus: true,
              decoration: InputDecoration(
                hasFloatingPlaceholder: false,
                hintText: "Buscar",
              ),
              controller: widget.searchController,
            ),
          ),
          Container(
            height: 35,
            child: VerticalDivider(),
          ),
          CategoriesChip(
            activeItem: widget.activeItem,
            small: true,
          ),
          // if (widget.sent)
          //   Positioned(
          //     top: 15,
          //     right: 0,
          //     child: Container(
          //       width: 15,
          //       height: 15,
          //       child: CircularProgressIndicator(
          //         strokeWidth: 2,
          //       ),
          //     ),
          //   )
        ],
      ),
    );
  }
}
