import 'package:flutter/material.dart';

class ComunidadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "COMUNIDAD",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(45),
        child: Center(
          child: Text(
            '"PROXIMAMENTE COMUNIDAD ARRANCANDO: arma tu evento , arma tu menu, te ayudamos en el cálculo, compartilo con los invitados, delega las compras, etc.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
