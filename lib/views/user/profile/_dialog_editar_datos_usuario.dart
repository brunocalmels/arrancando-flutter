import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogEditarDatosUsuario extends StatefulWidget {
  final String campo;
  final String valor;

  DialogEditarDatosUsuario({
    this.campo,
    this.valor,
  });

  @override
  _DialogEditarDatosUsuarioState createState() =>
      _DialogEditarDatosUsuarioState();
}

class _DialogEditarDatosUsuarioState extends State<DialogEditarDatosUsuario> {
  final formKey = GlobalKey<FormState>();
  TextEditingController textoController = TextEditingController();
  bool _sent = false;
  bool _errorHappended = false;
  String _errorText;

  Future _actualizarDato() async {
    try {
      ResponseObject resp = await Fetcher.put(
        url: "/users/${Provider.of<MyState>(context).activeUser.id}.json",
        body: {
          "${widget.campo.toLowerCase()}": "${textoController.text}",
        },
      );

      if (resp?.status == 200) {
        return true;
      } else {
        if (mounted)
          setState(() {
            _errorText = resp?.body != null ? resp.body : "Ocurrió un error";
          });
        throw "Error";
      }
    } catch (e) {
      if (mounted)
        setState(() {
          _errorHappended = true;
        });
    }
    return false;
  }

  usernameValidator(String value) {
    if (value.isEmpty) {
      return "El campo es obligatorio";
    } else {
      Pattern pattern =
          r'^(?=.{5,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value) || value.contains(".")) {
        return "Ingrese un username válido";
      } else {
        return null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    textoController.text = widget.valor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cambiar ${widget.campo.toLowerCase()}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Form(
            key: formKey,
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hasFloatingPlaceholder: true,
                labelText: "${widget.campo}",
              ),
              controller: textoController,
              validator: (value) =>
                  widget.campo == "Username" ? usernameValidator(value) : null,
            ),
          ),
          if (_errorHappended)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                _errorText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        FlatButton(
          onPressed: () async {
            setState(() {
              _errorHappended = false;
            });
            if (formKey.currentState.validate()) {
              setState(() {
                _sent = true;
              });
              bool result = await _actualizarDato();
              if (result) {
                setState(() {
                  _sent = false;
                  _errorHappended = false;
                });
                Navigator.of(context).pop(textoController.text);
              } else {
                setState(() {
                  _sent = false;
                });
              }
            }
          },
          child: _sent
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Text('Guardar'),
        ),
      ],
    );
  }
}
