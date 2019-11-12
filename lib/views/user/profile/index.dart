import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:arrancando/views/home/app_bar/_dialog_category_select.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  final GlobalSingleton gs = GlobalSingleton();

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
          ListTile(
            title: Text("Mi ciudad"),
            subtitle: Text(
              gs.categories[SectionType.publicaciones]
                  .firstWhere((c) =>
                      c.id ==
                      Provider.of<MyState>(context)
                          .preferredCategories[SectionType.publicaciones])
                  .nombre,
            ),
            trailing: Icon(Icons.edit),
            onTap: () async {
              int ciudadId = await showDialog(
                context: context,
                builder: (_) => DialogCategorySelect(),
              );
              if (ciudadId != null) {
                Provider.of<MyState>(context, listen: false)
                    .setPreferredCategories(
                  SectionType.publicaciones,
                  ciudadId,
                );
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setInt("preferredCiudadId", ciudadId);
              }
            },
          ),
        ],
      ),
    );
  }
}
