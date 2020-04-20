import 'package:arrancando/views/home/app_bar/_categories_chip.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onChanged;

  SearchField({
    this.searchController,
    this.onChanged,
  });

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hasFloatingPlaceholder: false,
                hintText: "Buscar",
              ),
              controller: widget.searchController,
            ),
          ),
        ],
      ),
    );
  }
}
