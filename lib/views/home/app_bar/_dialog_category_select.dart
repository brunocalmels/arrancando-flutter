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
  final bool pubCateg;
  final bool poiCity;

  DialogCategorySelect({
    this.selectCity = false,
    this.allowDismiss = true,
    this.titleText = 'Cambiar filtro',
    this.insideProfile = false,
    this.pubCateg = false,
    this.poiCity = false,
  });

  @override
  _DialogCategorySelectState createState() => _DialogCategorySelectState();
}

class _DialogCategorySelectState extends State<DialogCategorySelect> {
  final GlobalSingleton singleton = GlobalSingleton();
  int _selected;

  void _onItemTap(item) {
    _selected = item.id;
    CategoryWrapper.saveFilter(
      context,
      widget.pubCateg
          ? SectionType.publicaciones_categoria
          : widget.poiCity
              ? SectionType.pois_ciudad
              : context.read<MainState>().activePageHome,
      _selected,
    );
    if (mounted) setState(() {});
    Navigator.of(context).pop(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.allowDismiss ? true : _selected != null,
      child: AlertDialog(
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        title: Container(
          padding: const EdgeInsets.all(15),
          color: Theme.of(context).backgroundColor,
          child: Text(
            widget.titleText.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.selectCity)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                  child: Text(
                    'Si tu ciudad no aparece en el listado, seleccioná Neuquén y contactate con nosotros a través de la sección de perfil para que la agregemos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ),
              (widget.selectCity || widget.poiCity) && !widget.pubCateg
                  ? TypeAheadCiudad(
                      onItemTap: _onItemTap,
                      insideProfile: widget.insideProfile,
                      // insideEdit: widget.poiCity,
                    )
                  : Container(
                      // height: 220,
                      child: Builder(
                        builder: (context) {
                          final _lista = widget.pubCateg
                              ? [
                                  ...singleton.categories[
                                      SectionType.publicaciones_categoria]
                                ]
                              : widget.selectCity
                                  ? [
                                      ...singleton
                                          .categories[SectionType.publicaciones]
                                    ]
                                  : [
                                      ...singleton.categories[context
                                          .select<MainState, SectionType>(
                                              (value) => value.activePageHome)]
                                    ];

                          if ((widget.selectCity && !widget.pubCateg) ||
                              context.select<MainState, SectionType>(
                                      (value) => value.activePageHome) ==
                                  SectionType.pois) {
                            _lista.removeWhere((c) => c.id == -1);
                          }

                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    '(${_lista.length} items)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                ..._lista
                                    .map(
                                      (item) => ListTile(
                                        onTap: () {
                                          _onItemTap(item);
                                        },
                                        // leading: Icon(Icons.location_on),
                                        title: Text(item.nombre),
                                      ),
                                    )
                                    .toList(),
                              ],
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
