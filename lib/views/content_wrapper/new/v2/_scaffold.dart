import 'package:flutter/material.dart';

class NewContentScaffold extends StatelessWidget {
  final double _opacity = 0.6;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<FormState> formKey;
  final String title;
  final List<Widget> children;

  NewContentScaffold({
    @required this.scaffoldKey,
    @required this.formKey,
    @required this.title,
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool salir = await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Volver atrás"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Si salís ahora vas a perder el contenido que estabas creando.\n\n¿Realmente querés salir?",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("Volver"),
              ),
            ],
          ),
        );
        if (salir != null && salir) {
          return true;
        }
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color(0xff303d53),
                Theme.of(context).backgroundColor,
              ],
            ),
          ),
          child: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              Positioned(
                left: 0,
                top: 0,
                child: Opacity(
                  opacity: _opacity,
                  child: Image.asset(
                    "assets/images/content/new/wok.png",
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Opacity(
                  opacity: _opacity,
                  child: Image.asset(
                    "assets/images/content/new/tomates.png",
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Opacity(
                  opacity: _opacity,
                  child: Image.asset(
                    "assets/images/content/new/cubiertos.png",
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Opacity(
                  opacity: _opacity,
                  child: Image.asset(
                    "assets/images/content/new/fideos.png",
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                        ...children,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
