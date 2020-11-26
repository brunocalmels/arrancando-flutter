import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/services/utils.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_page_categorias_poi.dart';
import 'package:flutter/material.dart';

class SelectorCategoriaPoi extends StatelessWidget {
  final String label;
  final Function(CategoryWrapper) setCategoria;
  final CategoryWrapper categoria;

  SelectorCategoriaPoi({
    @required this.label,
    @required this.setCategoria,
    this.categoria,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$label:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    color: Color(Utils.activeTheme(context) == ThemeMode.light
                        ? 0xffcccccc
                        : 0xff262a3d),
                    child: Text(
                      categoria != null && categoria.nombre != null
                          ? categoria.nombre
                          : 'SELECCIONAR',
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                type: MaterialType.card,
                child: InkWell(
                  onTap: () async {
                    dynamic selectedCategoria =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PageCategoriasPoi(),
                      ),
                    );
                    if (selectedCategoria != null) {
                      setCategoria(selectedCategoria);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
