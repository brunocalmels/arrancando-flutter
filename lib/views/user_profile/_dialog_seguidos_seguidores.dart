import 'dart:convert';

import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/user_profile/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DialogSeguidosSeguidores extends StatelessWidget {
  final int userId;
  final bool isSeguidores;

  DialogSeguidosSeguidores({
    @required this.userId,
    this.isSeguidores = false,
  });

  Future<List<Usuario>> _fetchItems() async {
    ResponseObject resp = await Fetcher.get(
      url:
          "/seguimientos/$userId/${isSeguidores ? 'seguidores.json' : 'seguidos.json'}",
    );

    if (resp != null && resp.body != null) {
      return (json.decode(resp.body) as List)
          .map((e) => Usuario.fromJson(e))
          .toList();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isSeguidores ? "Seguidores" : "Seguidos"),
      content: FutureBuilder<List<Usuario>>(
        future: _fetchItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data.isNotEmpty) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: snapshot.data
                      .map(
                        (u) => Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => UserProfilePage(
                                    user: u,
                                  ),
                                  settings:
                                      RouteSettings(name: 'UserProfilePage'),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        u != null && u.avatar != null
                                            ? CachedNetworkImageProvider(
                                                "${MyGlobals.SERVER_URL}${u.avatar}",
                                              )
                                            : null,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "@${u.username}",
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
                ),
              );
            }
            return Text("No hay elementos.");
          }
          return Container(
            height: 50,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Volver"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
