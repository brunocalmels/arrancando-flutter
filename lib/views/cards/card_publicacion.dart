import 'package:arrancando/config/models/publicacion.dart';
import 'package:arrancando/config/my_globals.dart';
import 'package:flutter/material.dart';

class CardPublicacion extends StatelessWidget {
  final Publicacion publicacion;

  CardPublicacion({
    this.publicacion,
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
                  "${MyGlobals.SERVER_URL}${publicacion.imagenes.first}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x77000000),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
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
                        publicacion.fecha,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      // SizedBox(
                      //   width: 25,
                      //   child: PopupMenuButton<int>(
                      //     icon: Icon(
                      //       Icons.more_vert,
                      //       color: Colors.white,
                      //     ),
                      //     onSelected: (i) async {
                      //       print(i);
                      //     },
                      //     itemBuilder: (BuildContext context) {
                      //       return [
                      //         PopupMenuItem<int>(
                      //           value: 0,
                      //           child: Text("Comprartir"),
                      //         ),
                      //       ];
                      //     },
                      //   ),
                      // ),
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
                        publicacion.titulo,
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
                        publicacion.cuerpo,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "4.3",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "(",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "25",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                          Text(
                            ")",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
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
