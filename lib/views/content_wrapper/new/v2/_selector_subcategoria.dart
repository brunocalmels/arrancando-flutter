import 'package:arrancando/config/models/subcategoria_receta.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_page_subcategorias.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                    color: Color(Provider.of<MainState>(context).activeTheme ==
                            ThemeMode.light
                        ? 0xffcccccc
                        : 0xff262a3d),
                    child: Text(
                      subcategorias != null && subcategorias.isNotEmpty
                          ? subcategorias
                              .map((s) => s.nombre)
                              .toList()
                              .join(', ')
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
                    final selectedSubCategorias =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PageSubCategorias(
                          selectedCategorias: subcategorias,
                        ),
                      ),
                    ) as List<SubcategoriaReceta>;
                    if (selectedSubCategorias != null &&
                        selectedSubCategorias.isNotEmpty) {
                      setSubCategorias(selectedSubCategorias);
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
