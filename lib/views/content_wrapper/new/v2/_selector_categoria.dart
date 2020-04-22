import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_page_categorias.dart';
import 'package:flutter/material.dart';

class SelectorCategoria extends StatelessWidget {
  final String label;
  final Function(CategoryWrapper) setCategoria;
  final CategoryWrapper categoria;

  SelectorCategoria({
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
                    "$label:",
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
                    color: Color(0xff1a1c28),
                    child: Text(
                      categoria != null && categoria.nombre != null
                          ? categoria.nombre
                          : "DEFINIR",
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
                    CategoryWrapper selectedCategoria =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PageCategorias(),
                      ),
                    );
                    if (selectedCategoria != null)
                      setCategoria(selectedCategoria);
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
