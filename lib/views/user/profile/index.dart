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

  Future<void> _setAvatar(String base64) async {
    _sent = true;
    if (mounted) setState(() {});

    final resp = await Fetcher.post(
      url: '/avatar.json',
      body: {
        'avatar': base64,
      },
    );

    if (resp?.status == 200 && resp?.body != null) {
      final prefs = await SharedPreferences.getInstance();

      final au = Provider.of<UserState>(context, listen: false).activeUser;

      au.avatar = json.decode(resp.body)['avatar'];

      await prefs.setString(
        'activeUser',
        '${json.encode(au.toJson())}',
      );

      Provider.of<UserState>(context, listen: false).setActiveUser(
        ActiveUser.fromJson(au.toJson()),
      );
    }

    _sent = false;
    if (mounted) setState(() {});
  }

  Future<void> _updateActiveUser(context, campo, valor) async {
    final prefs = await SharedPreferences.getInstance();

    final _activeUser =
        Provider.of<UserState>(context, listen: false).activeUser;

    switch (campo) {
      case 'Nombre':
        _activeUser.nombre = valor;
        break;
      case 'Apellido':
        _activeUser.apellido = valor;
        break;
      case 'Nombre de usuario':
        _activeUser.username = valor;
        break;
      case 'Email':
        _activeUser.email = valor;
        break;
      case 'Instagram':
        _activeUser.urlInstagram = valor;
        break;
      default:
    }

    Provider.of<UserState>(context, listen: false).setActiveUser(_activeUser);

    await prefs.setString('activeUser', json.encode(_activeUser));
  }

  Future<bool> _getCiudadPopulada(id) async {
    final resp = await Fetcher.get(url: '/ciudades/$id.json');
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
      ),
      body: Consumer<UserState>(
        builder: (context, userState, child) {
          return ListView(
            children: <Widget>[
              Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  AvatarPicker(
                    currentAvatar: userState.activeUser?.avatar != null
                        ? CachedNetworkImageProvider(
                            '${MyGlobals.SERVER_URL}${userState.activeUser?.avatar}',
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
                subtitle: Text(userState.activeUser.nombre),
                onTap: () async {
                  final valor = await showDialog(
                    context: context,
                    builder: (context) {
                      return DialogEditarDatosUsuario(
                        campo: 'Nombre',
                        valor: userState.activeUser.nombre,
                      );
                    },
                  );
                  if (valor != null) {
                    await _updateActiveUser(context, 'Nombre', valor);
                  }
                },
                trailing: Icon(
                  Icons.edit,
                  color: Theme.of(context).accentColor,
                ),
              ),
              ListTile(
                title: Text('Apellido'),
                subtitle: Text(userState.activeUser.apellido ?? ''),
                onTap: () async {
                  final valor = await showDialog(
                    context: context,
                    builder: (context) {
                      return DialogEditarDatosUsuario(
                        campo: 'Apellido',
                        valor: userState.activeUser.apellido,
                      );
                    },
                  );
                  if (valor != null) {
                    await _updateActiveUser(context, 'Apellido', valor);
                  }
                },
                trailing: Icon(
                  Icons.edit,
                  color: Theme.of(context).accentColor,
                ),
              ),
              ListTile(
                title: Text('Nombre de usuario'),
                subtitle: Text('@${userState.activeUser.username}'),
                onTap: () async {
                  final valor = await showDialog(
                    context: context,
                    builder: (context) {
                      return DialogEditarDatosUsuario(
                        campo: 'Nombre de usuario',
                        valor: userState.activeUser.username,
                      );
                    },
                  );
                  if (valor != null) {
                    await _updateActiveUser(
                        context, 'Nombre de usuario', valor);
                  }
                },
                trailing: Icon(
                  Icons.edit,
                  color: Theme.of(context).accentColor,
                ),
              ),
              ListTile(
                title: Text('Email'),
                subtitle: Text(userState.activeUser.email),
                onTap: () async {
                  final valor = await showDialog(
                    context: context,
                    builder: (context) {
                      return DialogEditarDatosUsuario(
                        campo: 'Email',
                        valor: userState.activeUser.email,
                      );
                    },
                  );
                  if (valor != null) {
                    await _updateActiveUser(context, 'Email', valor);
                  }
                },
                trailing: Icon(
                  Icons.edit,
                  color: Theme.of(context).accentColor,
                ),
              ),
              ListTile(
                title: Text('Instagram'),
                subtitle: Text(
                  userState.activeUser.urlInstagram != null
                      ? 'https://instagram.com/${userState.activeUser.urlInstagram}'
                      : 'Perfil de Instagram',
                ),
                onTap: () async {
                  final valor = await showDialog(
                    context: context,
                    builder: (context) {
                      return DialogEditarDatosUsuario(
                        campo: 'Instagram',
                        valor: userState.activeUser.urlInstagram,
                      );
                    },
                  );
                  if (valor != null) {
                    await _updateActiveUser(context, 'Instagram', valor);
                  }
                },
                trailing: Icon(
                  Icons.edit,
                  color: Theme.of(context).accentColor,
                ),
              ),
              ListTile(
                title: Text('Mi ciudad'),
                subtitle: Text(
                  gs.categories[SectionType.publicaciones]
                      .firstWhere((c) =>
                          c.id ==
                          userState
                              .preferredCategories[SectionType.publicaciones])
                      .nombre,
                ),
                trailing: Icon(
                  Icons.edit,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () async {
                  final ciudadId = await showDialog(
                    context: context,
                    builder: (_) => DialogCategorySelect(
                      selectCity: true,
                      titleText: '¿Cuál es tu ciudad?',
                      insideProfile: true,
                    ),
                  );
                  if (ciudadId != null) {
                    userState.setPreferredCategories(
                      SectionType.publicaciones,
                      ciudadId,
                    );
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('preferredCiudadId', ciudadId);

                    if (!(await _getCiudadPopulada(ciudadId))) {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('No hay contenido'),
                          content: Text(
                            'Aún no hay mucho contenido de tu ciudad.\nEn unos días añadiremos publicaciones y tiendas cerca tuyo.\nMientras tanto, te recomendamos que veas el contenido de Neuquén.',
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
          );
        },
      ),
    );
  }
}
