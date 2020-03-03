import 'package:arrancando/config/state/content_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController searchController;

  SearchBar({
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
            Provider.of<ContentPageState>(context)
                .setSearchResultsVisible(true);
            await Future.delayed(Duration(seconds: 3));
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
