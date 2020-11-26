import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/user.dart';
// import 'package:arrancando/views/home/app_bar/_dialog_category_select.dart';
import 'package:arrancando/views/home/index.dart';
import 'package:arrancando/views/user/login/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignupPage> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalSingleton singleton = GlobalSingleton();

  bool sent = false;
  bool _obscurePassword = true;

  String emailValidator(value) {
    if (value.isEmpty) {
      return 'El campo es obligatorio';
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,1}\.[0-9]{1,1}\.[0-9]{1,1}\.[0-9]{1,1}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{1,}))$';
      // r'^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      final regex = RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return 'Ingrese un email válido';
      } else {
        return null;
      }
    }
  }

  String usernameValidator(String value) {
    if (value.isEmpty) {
      return 'El campo es obligatorio';
    } else {
      Pattern pattern =
          r'^(?=.{6,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$';
      final regex = RegExp(pattern);
      if (!regex.hasMatch(value) || value.contains('.')) {
        return 'Ingrese un username válido';
      } else {
        return null;
      }
    }
  }

  String requiredValidator(value) {
    if (value.isEmpty) {
      return 'El campo es obligatorio';
    } else {
      return null;
    }
  }

  Future attemptSignup(
    nombre,
    apellido,
    username,
    email,
    password,
  ) async {
    try {
      final resp = await Fetcher.post(
        url: '/users.json',
        unauthenticated: true,
        throwError: true,
        body: {
          'user': {
            'nombre': nombre,
            'apellido': apellido,
            'username': username,
            'email': email,
            'password': password,
          },
        },
      );

      if (resp.status == 201) {
        return json.decode(resp.body);
      } else {
        print('Signup error');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _signup(BuildContext buildContext) async {
    if (formKey.currentState.validate()) {
      setState(() {
        sent = true;
      });
      dynamic body = await attemptSignup(
        nombreController.text,
        apellidoController.text,
        usernameController.text,
        emailController.text,
        passwordController.text,
      );
      final prefs = await SharedPreferences.getInstance();
      if (body != null && body['auth_token'] != null) {
        await prefs.setString(
          'activeUser',
          '${json.encode(body)}',
        );
        Provider.of<UserState>(context, listen: false).setActiveUser(
          ActiveUser.fromJson(body),
        );

        await CategoryWrapper.loadCategories();

        if (prefs.getInt('preferredCiudadId') == null) {
          // int ciudadId = await showDialog(
          //   context: context,
          //   builder: (_) => DialogCategorySelect(
          //     selectCity: true,
          //     titleText: '¿Cuál es tu ciudad?',
          //     allowDismiss: false,
          //   ),
          // );
          final ciudadId = singleton.categories[SectionType.publicaciones]
              .where((c) => c.id > 0)
              .first
              .id;

          if (ciudadId != null) {
            Provider.of<UserState>(context, listen: false)
                .setPreferredCategories(
              SectionType.publicaciones,
              ciudadId,
            );
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('preferredCiudadId', ciudadId);
          }
        }

        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => MainScaffold(),
            settings: RouteSettings(name: 'Home'),
          ),
          (_) => false,
        );

        ///
      } else {
        _scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
          content: Text('Error al crear cuenta'),
        ));
      }
      if (mounted) {
        setState(() {
          sent = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Salir'),
                content: Text('¿Estás seguro que querés salir?'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No'),
                  ),
                  FlatButton(
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    child: Text('Si'),
                  )
                ],
              );
            });
        return false;
      },
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 35,
                      ),
                      Text(
                        'CREAR CUENTA',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: nombreController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Nombre',
                          hintText: 'Pablo',
                        ),
                        validator: (value) => requiredValidator(value),
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: apellidoController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Apellido',
                          hintText: 'Gomez',
                        ),
                        validator: (value) => requiredValidator(value),
                      ),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Nombre de usuario',
                          hintText: 'pablo_gomez27',
                        ),
                        validator: (value) => usernameValidator(value),
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Email',
                          hintText: 'usuario@ejemplo.com',
                        ),
                        validator: (value) => emailValidator(value),
                      ),
                      Stack(
                        fit: StackFit.passthrough,
                        children: <Widget>[
                          TextFormField(
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Contraseña',
                              hintText: '*********',
                            ),
                            validator: (value) => requiredValidator(value),
                          ),
                          Positioned(
                            top: 10,
                            right: 0,
                            child: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: _obscurePassword
                                    ? Colors.black12
                                    : Colors.black38,
                              ),
                              onPressed: () {
                                _obscurePassword = !_obscurePassword;
                                setState(() {});
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Builder(
                        // NECESITA EL CONTEXT PARA EL SNACKBAR
                        builder: (context) => RaisedButton(
                          onPressed: () {
                            _signup(context);
                          },
                          child: Text(
                            'Crear cuenta',
                          ),
                        ),
                      ),
                      if (MyGlobals.SHOW_DEV_LOGIN)
                        Builder(
                          // NECESITA EL CONTEXT PARA EL SNACKBAR
                          builder: (context) => FlatButton(
                            onPressed: () {
                              nombreController.text = 'hola';
                              apellidoController.text = 'bai';
                              usernameController.text = 'holabai';
                              emailController.text = 'holabai@gm.co';
                              passwordController.text = '123456';
                              _signup(context);
                            },
                            child: Text(
                              'holabai@gm.co',
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 25,
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => LoginPage(),
                              settings: RouteSettings(name: 'Login'),
                            ),
                          );
                        },
                        child: Text(
                          'Ya tengo cuenta',
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: sent
                              ? CircularProgressIndicator(
                                  strokeWidth: 2,
                                )
                              : Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
