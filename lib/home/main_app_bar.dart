import 'package:flutter/material.dart';

class MainAppBar extends StatefulWidget {
  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;
  bool _sent = false;

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
          ? Form(
              key: _formKey,
              child: Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  TextFormField(
                    onChanged: (val) {
                      setState(() {
                        _sent = true;
                      });
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                      hasFloatingPlaceholder: false,
                      hintText: "Buscar",
                    ),
                    controller: _searchController,
                  ),
                  if (_sent)
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
            )
          : Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  size: 15,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Neuquén',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
      actions: <Widget>[
        IconButton(
          onPressed: _toggleSearch,
          icon: Icon(Icons.search),
        )
      ],
    );
  }
}
