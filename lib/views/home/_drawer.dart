import 'package:arrancando/config/state/index.dart';
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
            padding: const EdgeInsets.all(0),
            child: Container(
              color: Colors.black12,
              child: Center(
                child: Text(Provider.of<MyState>(context).activeUser != null
                    ? Provider.of<MyState>(context).activeUser.email
                    : 'No user'),
              ),
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
          )
        ],
      ),
    );
  }
}
