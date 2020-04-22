import 'package:arrancando/config/models/subcategoria_receta.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_page_subcategorias.dart';
import 'package:flutter/material.dart';

class SelectorSubCategoria extends StatelessWidget {
  final String label;
  final Function(List<SubcategoriaReceta>) setSubCategorias;
  final List<SubcategoriaReceta> subcategorias;

  SelectorSubCategoria({
    @required this.label,
    @required this.setSubCategorias,
    this.subcategorias,
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
              child: Wrap(
                runSpacing: 3,
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
                      subcategorias != null && subcategorias.length > 0
                          ? subcategorias
                              .map((s) => s.nombre)
                              .toList()
                              .join(", ")
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
                    List<SubcategoriaReceta> selectedSubCategorias =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PageSubCategorias(
                          selectedCategorias: subcategorias,
                        ),
                      ),
                    );
                    if (selectedSubCategorias != null &&
                        selectedSubCategorias.length > 0)
                      setSubCategorias(selectedSubCategorias);
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
