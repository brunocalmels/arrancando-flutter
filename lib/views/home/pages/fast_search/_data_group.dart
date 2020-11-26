import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/services/utils.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:arrancando/views/home/pages/fast_search/_content_tile.dart';
import 'package:arrancando/views/search/_search_users.dart';
import 'package:arrancando/views/search/index.dart';
import 'package:arrancando/views/user_profile/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataGroup extends StatelessWidget {
  final bool fetching;
  final IconData icon;
  final String title;
  final SectionType type;
  final TextEditingController searchController;
  final List<ContentWrapper> items;
  final List<Usuario> itemsUsuarios;
  final bool isUsers;

  DataGroup({
    @required this.fetching,
    @required this.icon,
    @required this.title,
    @required this.searchController,
    this.items,
    this.itemsUsuarios,
    this.type,
    this.isUsers = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          color: Colors.black12,
          height: 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Icon(
                  icon,
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  title,
                ),
              ],
            ),
          ),
        ),
        fetching
            ? LoadingWidget(
                height: 200,
              )
            : (items == null && itemsUsuarios == null)
                ? Container(
                    height: 100,
                    child: Center(
                      child: Text('Ocurrió un error'),
                    ),
                  )
                : ((items == null || items.isEmpty) &&
                        (itemsUsuarios == null || itemsUsuarios.isEmpty))
                    ? Container(
                        height: 100,
                        child: Center(
                          child: Text('No se encontraron resultados'),
                        ),
                      )
                    : Column(
                        children: <Widget>[
                          if (isUsers)
                            ...itemsUsuarios
                                .map(
                                  (i) => Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => UserProfilePage(
                                              user: i,
                                            ),
                                            settings: RouteSettings(
                                              name: 'UserProfilePage',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 15,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundImage: i != null &&
                                                      i.avatar != null
                                                  ? CachedNetworkImageProvider(
                                                      '${MyGlobals.SERVER_URL}${i.avatar}',
                                                    )
                                                  : null,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                '@${i.username}',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          if (!isUsers)
                            ...items
                                .map(
                                  (i) => ContentTile(
                                    content: i,
                                    type: type,
                                  ),
                                )
                                .toList(),
                          FlatButton(
                            onPressed: () {
                              Utils.unfocus(context);

                              if (isUsers) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => SearchPageUsers(
                                      originalSearch: searchController.text,
                                    ),
                                    settings:
                                        RouteSettings(name: 'SearchPageUsers'),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => SearchPage(
                                      originalType: type,
                                      originalSearch: searchController.text,
                                    ),
                                    settings: RouteSettings(name: 'Search'),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'VER MÁS',
                              style: TextStyle(
                                color: Provider.of<MainState>(context)
                                            .activeTheme ==
                                        ThemeMode.light
                                    ? null
                                    : Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
      ],
    );
  }
}
