import 'dart:io';

import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/services/utils.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/comunidad/index.dart';
import 'package:arrancando/views/contacto/index.dart';
import 'package:arrancando/views/content_wrapper/saved/index.dart';
import 'package:arrancando/views/privacy-policy/index.dart';
import 'package:arrancando/views/reglas/index.dart';
import 'package:arrancando/views/user/login/index.dart';
import 'package:arrancando/views/user/profile/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(0xff59606e),
      ),
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          Provider.of<UserState>(context, listen: false)
                                          .activeUser !=
                                      null &&
                                  Provider.of<UserState>(context, listen: false)
                                          .activeUser
                                          .avatar !=
                                      null
                              ? CachedNetworkImageProvider(
                                  "${MyGlobals.SERVER_URL}${Provider.of<UserState>(context, listen: false).activeUser.avatar}",
                                )
                              : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(Provider.of<UserState>(context, listen: false)
                                .activeUser !=
                            null
                        ? Provider.of<UserState>(context, listen: false)
                            .activeUser
                            .username
                        : ""),
                  ],
                ),
              ),
              Material(
                color: Theme.of(context).backgroundColor,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.account_box,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Text('Perfil'),
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProfilePage(),
                              settings: RouteSettings(name: 'Profile'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.bookmark,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Text('Guardadas'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SavedContentPage(),
                              settings: RouteSettings(name: 'Saved'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        // leading: Icon(Icons.share, color: Theme.of(context).accentColor,),
                        leading: Icon(
                          Icons.update,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Text('Buscar actualizaciones'),
                        // subtitle: Text('Enviá el link para que la descarguen.'),
                        onTap: () async {
                          String url =
                              'https://play.google.com/store/apps/details?id=com.macherit.arrancando';
                          if (Platform.isIOS)
                            url =
                                'https://apps.apple.com/us/app/arrancando/id1490590335?l=es';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.security,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Text('Política de privacidad'),
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PrivacyPolicyPage(),
                              settings: RouteSettings(name: 'Privacy policy'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.people,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Text('Comunidad Arrancando'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ComunidadPage(),
                              settings: RouteSettings(name: 'Comunidad'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.security,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Text('Reglas'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ReglasPage(),
                              settings: RouteSettings(name: 'Reglas'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.live_help,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Text('Contacto'),
                        subtitle: Text(
                            "Contactate con nosotros por dudas o consultas."),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ContactPage(),
                              settings: RouteSettings(name: 'Contacto'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.send,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Text('Compartí la aplicación'),
                        // subtitle: Text('Enviá el link para que la descarguen.'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Image.asset(
                                  'assets/images/logo-facebook.png'),
                              onPressed: () {
                                Share.text(
                                  'Compartir contenido',
                                  'https://arrancando.com.ar/',
                                  'text/plain',
                                );
                              },
                            ),
                            IconButton(
                              color: Colors.black45,
                              icon: Icon(
                                Icons.share,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: () async {
                                var img = (await rootBundle
                                        .load('assets/images/icon.png'))
                                    .buffer
                                    .asUint8List();

                                Share.file(
                                  'Compartir imagen',
                                  'imagen.jpg',
                                  img,
                                  'image/jpg',
                                  text:
                                      "Bajate Arrancando y compartí tu pasión por el asado y el buen comer.\n\nAndroid: https://play.google.com/store/apps/details?id=com.macherit.arrancando\n\niOS: https://apps.apple.com/us/app/arrancando/id1490590335?l=es",
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Text(
                          'Tema ${Provider.of<MainState>(context).activeTheme == ThemeMode.dark ? 'claro' : 'oscuro'}',
                        ),
                        onTap: () => Utils.toggleThemeMode(context),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.exit_to_app,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Text('Cerrar sesión'),
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('activeUser');
                          Provider.of<UserState>(context, listen: false)
                              .setActiveUser(null);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => LoginPage(),
                              settings: RouteSettings(name: 'Login'),
                            ),
                            (_) => false,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              "Versión: ${MyGlobals.APP_VERSION}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
