import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final bool sent;
  final Function setSent;
  final TextEditingController searchController;

  SearchBar({
    this.sent,
    this.setSent,
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
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          TextFormField(
            onChanged: (val) async {
              widget.setSent(true);
              await Future.delayed(Duration(seconds: 3));
              widget.setSent(false);
            },
            autofocus: true,
            decoration: InputDecoration(
              hasFloatingPlaceholder: false,
              hintText: "Buscar",
            ),
            controller: widget.searchController,
          ),
          if (widget.sent)
            Positioned(
              top: 15,
              right: 0,
              child: Container(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            )
        ],
      ),
    );
  }
}
