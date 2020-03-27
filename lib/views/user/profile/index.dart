import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/home/app_bar/_dialog_category_select.dart';
import 'package:arrancando/views/user/profile/_avatar_picker.dart';
import 'package:arrancando/views/user/profile/_dialog_editar_datos_usuario.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalSingleton gs = GlobalSingleton();

  bool _sent = false;

  _setAvatar(String base64) async {
    setState(() {
      _sent = true;
    });

    ResponseObject resp = await Fetcher.post(
      url: "/avatar.json",
      body: {
        "avatar": base64,
      },
    );

    if (resp?.status == 200 && resp?.body != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ActiveUser au = Provider.of<UserState>(context, listen: false).activeUser;

      au.avatar = json.decode(resp.body)['avatar'];

      prefs.setString(
        'activeUser',
        "${json.encode(au.toJson())}",
      );

      Provider.of<UserState>(context, listen: false).setActiveUser(
        ActiveUser.fromJson(au.toJson()),
      );
    }

    setState(() {
      _sent = false;
    });
  }

  _updateActiveUser(context, campo, valor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ActiveUser _activeUser =
        Provider.of<UserState>(context, listen: false).activeUser;

    switch (campo) {
      case "Nombre":
        _activeUser.nombre = valor;
        break;
      case "Apellido":
        _activeUser.apellido = valor;
        break;
      case "Username":
        _activeUser.username = valor;
        break;
      default:
    }

    Provider.of<UserState>(context, listen: false).setActiveUser(_activeUser);

    prefs.setString("activeUser", json.encode(_activeUser));
  }

  Future<bool> _getCiudadPopulada(id) async {
    ResponseObject resp = await Fetcher.get(url: "/ciudades/$id.json");
    if (resp != null) {
      return json.decode(resp.body)['populada'] != null
          ? (json.decode(resp.body)['populada'] as bool)
          : false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              AvatarPicker(
                currentAvatar:
                    Provider.of<UserState>(context).activeUser?.avatar != null
                        ? CachedNetworkImageProvider(
                            "${MyGlobals.SERVER_URL}${Provider.of<UserState>(context).activeUser?.avatar}",
                          )
                        : null,
                setAvatar: _setAvatar,
              ),
              if (_sent)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.white30,
                    child: Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          ListTile(
            title: Text('Nombre'),
            subtitle: Text(Provider.of<UserState>(context).activeUser.nombre),
            onTap: () async {
              String valor = await showDialog(
                context: context,
                builder: (context) {
                  return DialogEditarDatosUsuario(
                    campo: "Nombre",
                    valor: Provider.of<UserState>(context).activeUser.nombre,
                  );
                },
              );
              if (valor != null) _updateActiveUser(context, "Nombre", valor);
            },
            trailing: Icon(Icons.edit),
          ),
          ListTile(
            title: Text('Apellido'),
            subtitle: Text(
                Provider.of<UserState>(context).activeUser.apellido != null
                    ? Provider.of<UserState>(context).activeUser.apellido
                    : ''),
            onTap: () async {
              String valor = await showDialog(
                context: context,
                builder: (context) {
                  return DialogEditarDatosUsuario(
                    campo: "Apellido",
                    valor: Provider.of<UserState>(context).activeUser.apellido,
                  );
                },
              );
              if (valor != null) _updateActiveUser(context, "Apellido", valor);
            },
            trailing: Icon(Icons.edit),
          ),
          ListTile(
            title: Text('Username'),
            subtitle: Text(Provider.of<UserState>(context).activeUser.username),
            onTap: () async {
              String valor = await showDialog(
                context: context,
                builder: (context) {
                  return DialogEditarDatosUsuario(
                    campo: "Username",
                    valor: Provider.of<UserState>(context).activeUser.username,
                  );
                },
              );
              if (valor != null) _updateActiveUser(context, "Username", valor);
            },
            trailing: Icon(Icons.edit),
          ),
          ListTile(
            title: Text("Mi ciudad"),
            subtitle: Text(
              gs.categories[SectionType.publicaciones]
                  .firstWhere((c) =>
                      c.id ==
                      Provider.of<UserState>(context)
                          .preferredCategories[SectionType.publicaciones])
                  .nombre,
            ),
            trailing: Icon(Icons.edit),
            onTap: () async {
              int ciudadId = await showDialog(
                context: context,
                builder: (_) => DialogCategorySelect(
                  selectCity: true,
                  titleText: "¿Cuál es tu ciudad?",
                  insideProfile: true,
                ),
              );
              if (ciudadId != null) {
                Provider.of<UserState>(context, listen: false)
                    .setPreferredCategories(
                  SectionType.publicaciones,
                  ciudadId,
                );
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setInt("preferredCiudadId", ciudadId);

                if (!(await _getCiudadPopulada(ciudadId))) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('No hay contenido'),
                      content: Text(
                        'Aún no hay mucho contenido de tu ciudad.\nEn unos días añadiremos publicaciones y puntos de interés cerca tuyo.\nMientras tanto, te recomendamos que veas el contenido de Neuquén.',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Aceptar'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
