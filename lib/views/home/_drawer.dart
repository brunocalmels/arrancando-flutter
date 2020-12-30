import 'dart:io';

import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/notificacion.dart';
import 'package:arrancando/config/services/utils.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/chat/grupo/index.dart';
import 'package:arrancando/views/contacto/index.dart';
import 'package:arrancando/views/content_wrapper/saved/index.dart';
import 'package:arrancando/views/general/_badge_wrapper.dart';
import 'package:arrancando/views/notificaciones/index.dart';
import 'package:arrancando/views/privacy-policy/index.dart';
import 'package:arrancando/views/reglas/index.dart';
import 'package:arrancando/views/user/login/index.dart';
import 'package:arrancando/views/user/profile/index.dart';
import 'package:arrancando/views/user_profile/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  Future<void> _fetchUnreadNotificaciones() async {
    var unreadNotificaciones = await Notificacion.fetchUnread();
    context
        .read<MainState>()
        .setUnreadNotifications(unreadNotificaciones.length);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUnreadNotificaciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MainState, UserState>(
      builder: (context, mainState, userState, child) => Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xff59606e),
        ),
        child: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Material(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => UserProfilePage(
                                  user: userState?.activeUser?.getUsuario,
                                ),
                                settings:
                                    RouteSettings(name: 'UserProfilePage'),
                              ),
                            );
                          },
                          child: DrawerHeader(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: userState.activeUser !=
                                              null &&
                                          userState.activeUser.avatar != null
                                      ? CachedNetworkImageProvider(
                                          '${MyGlobals.SERVER_URL}${userState.activeUser.avatar}',
                                        )
                                      : null,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(userState.activeUser != null
                                    ? '@${userState.activeUser.username}'
                                    : ''),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Ver mi perfil',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                          title: Text('Editar perfil'),
                          onTap: () async {
                            await Navigator.of(context).push(
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
                          leading: BadgeWrapper(
                            showBadge: mainState.unreadNotifications > 0,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Icon(
                                Icons.notifications,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                          title: Text('Notificaciones'),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => NotificacionesPage(),
                                settings:
                                    RouteSettings(name: 'NotificacionesPage'),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.people,
                            color: Theme.of(context).accentColor,
                          ),
                          title: Text('Comunidad'),
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (_) => ComunidadPage(),
                            //     settings: RouteSettings(name: 'Comunidad'),
                            //   ),
                            // );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => GrupoChatPage(),
                                settings: RouteSettings(name: 'GrupoChatPage'),
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
                            var url =
                                'https://play.google.com/store/apps/details?id=com.macherit.arrancando';
                            if (Platform.isIOS) {
                              url =
                                  'https://apps.apple.com/us/app/arrancando/id1490590335?l=es';
                            }
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
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PrivacyPolicyPage(),
                                settings: RouteSettings(name: 'Privacy policy'),
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
                              'Contactate con nosotros por dudas o consultas.'),
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

                                  await Share.file(
                                    'Compartir imagen',
                                    'imagen.jpg',
                                    img,
                                    'image/jpg',
                                    text:
                                        'Bajate Arrancando y compartí tu pasión por el asado y el buen comer.\n\nAndroid: https://play.google.com/store/apps/details?id=com.macherit.arrancando\n\niOS: https://apps.apple.com/us/app/arrancando/id1490590335?l=es',
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
                            'Tema ${mainState.activeTheme == ThemeMode.dark ? 'claro' : 'oscuro'}',
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
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove('activeUser');
                            userState.setActiveUser(null);
                            await Navigator.of(context).pushAndRemoveUntil(
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
                                'Versión: ${MyGlobals.APP_VERSION}',
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
      ),
    );
  }
}
