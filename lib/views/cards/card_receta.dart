import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/receta.dart';
import 'package:arrancando/views/cards/_row_puntajes.dart';
import 'package:flutter/material.dart';

class CardReceta extends StatelessWidget {
  final Receta receta;

  CardReceta({
    this.receta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.37,
      child: Card(
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Positioned(
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
                child: Image.network(
                  "${MyGlobals.SERVER_URL}${receta.imagenes.first}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              child: Material(
                color: Color(0x77000000),
                type: MaterialType.card,
                child: InkWell(
                  onTap: () {},
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 10,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        receta.fecha,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        receta.titulo,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        receta.cuerpo,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: Theme.of(context).textTheme.body1.merge(
                              TextStyle(
                                color: Colors.white,
                              ),
                            ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RowPuntajes(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
