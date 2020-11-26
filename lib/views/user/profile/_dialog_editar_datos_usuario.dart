import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/user.dart';
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
      final resp = await Fetcher.put(
        url: '/users/${Provider.of<UserState>(context).activeUser.id}.json',
        body: {
          '${widget.campo == 'Instagram' ? 'url_instagram' : widget.campo == 'Nombre de usuario' ? 'username' : widget.campo.toLowerCase()}':
              '${widget.campo == 'Instagram' ? 'https://instagram.com/${textoController.text}' : textoController.text}',
        },
      );

      if (resp?.status == 200) {
        return true;
      } else {
        _errorText = resp?.body != null ? resp.body : 'Ocurrió un error';
        if (mounted) setState(() {});
        throw 'Error';
      }
    } catch (e) {
      _errorHappended = true;
      if (mounted) setState(() {});
    }
    return false;
  }

  String usernameValidator(String value) {
    if (value.isEmpty) {
      return 'El campo es obligatorio';
    } else {
      Pattern pattern =
          r'^(?=.{5,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$';
      final regex = RegExp(pattern);
      if (!regex.hasMatch(value) || value.contains('.')) {
        return 'Ingrese un nombre de usuario válido';
      } else {
        return null;
      }
    }
  }

  String emailValidator(value) {
    if (value.isEmpty) {
      return 'El campo es obligatorio';
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,1}\.[0-9]{1,1}\.[0-9]{1,1}\.[0-9]{1,1}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{1,}))$';
      // r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      final regex = RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return 'Ingrese un email válido';
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
              textCapitalization: widget.campo == 'Instagram'
                  ? TextCapitalization.none
                  : TextCapitalization.sentences,
              keyboardType: widget.campo == 'Instagram'
                  ? TextInputType.url
                  : widget.campo == 'Email'
                      ? TextInputType.emailAddress
                      : null,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: '${widget.campo}',
                // prefixText:
                //     widget.campo == 'Instagram' ? 'https://in...com/ ' : null,
                // prefixStyle: widget.campo == 'Instagram'
                //     ? TextStyle(fontSize: 10)
                //     : null,
              ),
              controller: textoController,
              validator: (value) => widget.campo == 'Nombre de usuario'
                  ? usernameValidator(value)
                  : widget.campo == 'Email'
                      ? emailValidator(value)
                      : null,
            ),
          ),
          if (widget.campo == 'Instagram')
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '(Ingresá tu nombre de usuario de Instagram sin arroba)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                ),
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
