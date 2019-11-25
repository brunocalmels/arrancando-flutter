import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:arrancando/views/comunidad/index.dart';
import 'package:arrancando/views/content_wrapper/saved/index.dart';
import 'package:arrancando/views/general/splash.dart';
import 'package:arrancando/views/user/login/index.dart';
import 'package:arrancando/views/user/profile/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      Provider.of<MyState>(context, listen: false).activeUser !=
                                  null &&
                              Provider.of<MyState>(context, listen: false)
                                      .activeUser
                                      .avatar !=
                                  null
                          ? NetworkImage(
                              "${MyGlobals.SERVER_URL}${Provider.of<MyState>(context, listen: false).activeUser.avatar}",
                            )
                          : null,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(Provider.of<MyState>(context, listen: false).activeUser !=
                        null
                    ? Provider.of<MyState>(context, listen: false)
                        .activeUser
                        .username
                    : ""),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.account_box,
            ),
            title: Text('Perfil'),
            onTap: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProfilePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.bookmark,
            ),
            title: Text('Guardadas'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SavedContentPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.people,
            ),
            title: Text('Comunidad Arrancando'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ComunidadPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
            ),
            title: Text('Cerrar sesión'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('activeUser');
              Provider.of<MyState>(context, listen: false).setActiveUser(null);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => LoginPage(),
                ),
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
