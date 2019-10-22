import 'package:arrancando/views/home/app_bar/_categories_chip.dart';
import 'package:arrancando/views/home/app_bar/_search_bar.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatefulWidget {
  final int activeItem;

  MainAppBar({
    this.activeItem,
  });

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _sent = false;
  bool _showSearch = false;

  _toggleSearch() {
    _showSearch = !_showSearch;
    if (!_showSearch) {
      _searchController.clear();
      _sent = false;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      floating: true,
      snap: false,
      leading: Material(
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 20,
              ),
            ],
          ),
          onTap: () {},
        ),
      ),
      backgroundColor: Colors.transparent,
      title: _showSearch
          ? SearchBar(
              setSent: (bool val) {
                setState(() {
                  _sent = val;
                });
              },
              sent: _sent,
              searchController: _searchController,
            )
          : widget.activeItem > 0
              ? CategoriesChip(
                  activeItem: widget.activeItem,
                )
              : null,
      actions: <Widget>[
        IconButton(
          onPressed: _toggleSearch,
          icon: Icon(Icons.search),
        )
      ],
    );
  }
}
