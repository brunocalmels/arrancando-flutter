import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function(bool) setSent;
  final Function showSearchPage;
  final TextEditingController searchController;

  SearchBar({
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
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
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
    );
  }
}
