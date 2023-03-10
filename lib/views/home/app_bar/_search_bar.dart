import 'package:arrancando/config/state/content_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final Function(bool) setSearchVisibility;

  SearchBar({
    this.searchController,
    this.setSearchVisibility,
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
            widget.setSearchVisibility(true);
            context.read<ContentPageState>().setSearchResultsVisible(true);
            await Future.delayed(Duration(seconds: 3));
          }
        },
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: 'Buscar',
        ),
        controller: widget.searchController,
        autofocus: true,
      ),
    );
  }
}
