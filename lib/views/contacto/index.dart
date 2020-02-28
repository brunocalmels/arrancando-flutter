import 'package:arrancando/config/services/fetcher.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mensajeController = new TextEditingController();
  bool _sent = false;

  _requiredValidator(value) {
    if (value.isEmpty) {
      return "El campo es obligatorio";
    } else {
      return null;
    }
  }

  _enviarMensaje(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _sent = true;
      });

      try {
        if (mounted) FocusScope.of(context).requestFocus(FocusNode());

        ResponseObject resp = await Fetcher.post(
          url: "/contacto.json",
          body: {
            "mensaje": _mensajeController.text,
          },
        );

        if (resp.status == 200) {
          _mensajeController.clear();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Mensaje enviado correctamente, nos contactatemos a la brevedad.",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          );
        } else {
          throw resp.body;
        }
      } catch (e) {
        print(e);
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Ocurrió un error, intenta nuevamente más tarde.",
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          ),
        );
      }
      if (mounted)
        setState(() {
          _sent = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mensaje/Reporte",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Ponete en contacto con los administradores del sistema. Podés dejar un mensaje o reportar algún error. Te responderemos lo antes posible.",
                // textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: _mensajeController,
                      keyboardType: TextInputType.multiline,
                      minLines: 8,
                      maxLines: 8,
                      decoration: new InputDecoration(
                        alignLabelWithHint: true,
                        hasFloatingPlaceholder: true,
                        labelText: "Mensaje",
                        hintText: 'Cuerpo',
                      ),
                      validator: (value) => _requiredValidator(value),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Builder(
                          // NECESITA EL CONTEXT PARA EL SNACKBAR
                          builder: (context) => RaisedButton(
                            onPressed: _sent
                                ? null
                                : () {
                                    _enviarMensaje(context);
                                  },
                            child: _sent
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Enviar',
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
