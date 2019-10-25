import 'package:arrancando/views/home/app_bar/_categories_chip.dart';
import 'package:arrancando/views/home/app_bar/_search_bar.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatefulWidget {
  final int activeItem;
  final bool sent;
  final Function(bool) setSent;
  final Function showSearchPage;

  MainAppBar({
    this.activeItem,
    this.sent,
    this.setSent,
    this.showSearchPage,
  });

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;

  _toggleSearch() {
    _showSearch = !_showSearch;
    if (!_showSearch) {
      _searchController.clear();
      widget.setSent(false);
      widget.showSearchPage(false);
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
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 20,
            child: Material(
              color: Colors.transparent,
              type: MaterialType.circle,
              child: InkWell(
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      title: _showSearch
          ? SearchBar(
              activeItem: widget.activeItem,
              setSent: widget.setSent,
              showSearchPage: widget.showSearchPage,
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
          icon: Icon(
            _showSearch ? Icons.close : Icons.search,
          ),
        )
      ],
    );
  }
}
