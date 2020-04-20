import 'package:flutter/material.dart';

class ReglasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "REGLAS",
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(45),
        child: Center(
          child: Text(
            'Grupo para compartir nuestras experiencias en el asado de todo el mundo.\n\nNo hay fútbol, política, religión, promociones, ventas, beneficios o propaganda de ninguna clase. Esta aplicación está para compartir ideas de como cocinar todo aquello que relacione asar carne sobre fuego o brasas. No se permite la falta de respeto hacia otros usuarios y en estos casos la publicación o los malos comentarios serán eliminados.',
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
