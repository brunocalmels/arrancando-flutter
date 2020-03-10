import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/views/general/type_ahead_ciudad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogCategorySelect extends StatefulWidget {
  final bool selectCity;
  final bool allowDismiss;
  final String titleText;
  final bool insideProfile;

  DialogCategorySelect({
    this.selectCity = false,
    this.allowDismiss = true,
    this.titleText = "Cambiar filtro",
    this.insideProfile = false,
  });

  @override
  _DialogCategorySelectState createState() => _DialogCategorySelectState();
}

class _DialogCategorySelectState extends State<DialogCategorySelect> {
  final GlobalSingleton singleton = GlobalSingleton();
  int _selected;

  _onItemTap(item) {
    _selected = item.id;
    if (mounted) setState(() {});
    Navigator.of(context).pop(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.allowDismiss ? true : _selected != null,
      child: AlertDialog(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        title: Text(widget.titleText),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.selectCity)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                  child: Text(
                    "Si tu ciudad no aparece en el listado, seleccioná Neuquén y contactate con nosotros a través de la sección de perfil para que la agregemos.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ),
              widget.selectCity
                  ? TypeAheadCiudad(
                      onItemTap: _onItemTap,
                      insideProfile: widget.insideProfile,
                    )
                  : Container(
                      height: 220,
                      child: Builder(
                        builder: (context) {
                          List<CategoryWrapper> _lista = widget.selectCity
                              ? [
                                  ...singleton
                                      .categories[SectionType.publicaciones]
                                ]
                              : [
                                  ...singleton.categories[
                                      Provider.of<MainState>(context)
                                          .activePageHome]
                                ];

                          if (widget.selectCity)
                            _lista.removeWhere((c) => c.id == -1);

                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: _lista
                                  .map(
                                    (item) => ListTile(
                                      onTap: () {
                                        _onItemTap(item);
                                      },
                                      leading: Icon(Icons.location_on),
                                      title: Text(item.nombre),
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
        actions: <Widget>[
          if (widget.allowDismiss)
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
        ],
      ),
    );
  }
}
