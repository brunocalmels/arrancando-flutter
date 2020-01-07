import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/index.dart';
// import 'package:arrancando/views/home/app_bar/_dialog_category_select.dart';
import 'package:arrancando/views/home/index.dart';
import 'package:arrancando/views/user/login/_dev_login.dart';
import 'package:arrancando/views/user/signup/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final GlobalSingleton singleton = GlobalSingleton();

  bool sent = false;
  bool _obscurePassword = true;

  emailValidator(value) {
    if (value.isEmpty) {
      return "El campo es obligatorio";
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,1}\.[0-9]{1,1}\.[0-9]{1,1}\.[0-9]{1,1}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{1,}))$';
      // r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return "Ingrese un email válido";
      } else {
        return null;
      }
    }
  }

  requiredValidator(value) {
    if (value.isEmpty) {
      return "El campo es obligatorio";
    } else {
      return null;
    }
  }

  Future attemptLogin(email, password) async {
    try {
      ResponseObject resp = await Fetcher.post(
        url: "/authenticate.json",
        unauthenticated: true,
        throwError: true,
        body: {
          "email": email,
          "password": password,
        },
      );

      if (resp.status == 200) {
        return json.decode(resp.body);
      } else {
        print("Login error");
      }
    } catch (e) {
      print(e);
    }
  }

  _login(BuildContext buildContext) async {
    if (formKey.currentState.validate()) {
      setState(() {
        sent = true;
      });
      dynamic body = await attemptLogin(
        emailController.text,
        passwordController.text,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (body != null && body['auth_token'] != null) {
        prefs.setString(
          'activeUser',
          "${json.encode(body)}",
        );
        Provider.of<MyState>(context, listen: false).setActiveUser(
          ActiveUser.fromJson(body),
        );

        await CategoryWrapper.loadCategories();

        if (prefs.getInt("preferredCiudadId") == null) {
          // int ciudadId = await showDialog(
          //   context: context,
          //   builder: (_) => DialogCategorySelect(
          //     selectCity: true,
          //     titleText: "¿Cuál es tu ciudad?",
          //     allowDismiss: false,
          //   ),
          // );
          int ciudadId = singleton.categories[SectionType.publicaciones]
              .where((c) => c.id > 0)
              .first
              .id;
          if (ciudadId != null) {
            Provider.of<MyState>(context, listen: false).setPreferredCategories(
              SectionType.publicaciones,
              ciudadId,
            );
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setInt("preferredCiudadId", ciudadId);
          }
        }

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => MainScaffold(),
          ),
          (_) => false,
        );

        ///
      } else {
        Scaffold.of(buildContext).showSnackBar(
          SnackBar(
            content: Text("Error al iniciar sesión"),
          ),
        );
      }
      if (mounted)
        setState(() {
          sent = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Salir'),
                content: Text('¿Querés salir?'),
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
      child: Scaffold(
        body: Center(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 35,
                    ),
                    Image.asset(
                      "assets/images/icon.png",
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: new InputDecoration(
                        hasFloatingPlaceholder: true,
                        labelText: "Email",
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
                          decoration: new InputDecoration(
                            hasFloatingPlaceholder: true,
                            labelText: "Contraseña",
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
                                  ? Colors.black26
                                  : Colors.black54,
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
                          _login(context);
                        },
                        child: Text(
                          'Login',
                        ),
                      ),
                    ),
                    if (MyGlobals.SHOW_DEV_LOGIN)
                      DevLogin(
                        emailController: emailController,
                        passwordController: passwordController,
                        login: _login,
                      ),
                    SizedBox(
                      height: 25,
                    ),
                    RaisedButton(
                      color: Color(0xffdddddd),
                      onPressed: () async {
                        sent = true;
                        if (mounted) setState(() {});
                        const url =
                            "https://accounts.google.com/o/oauth2/auth?client_id=${MyGlobals.GOOGLE_CLIENT_ID}&redirect_uri=${MyGlobals.GOOGLE_REDIRECT_URI}&scope=https://www.googleapis.com/auth/userinfo.email&response_type=code&access_type=offline";
                        if (await canLaunch(url)) {
                          await launch(
                            url,
                            forceSafariVC: false,
                            forceWebView: false,
                          );
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Iniciar con',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            "assets/images/logo-google.png",
                            width: 22,
                            height: 22,
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                      color: Color(0xffdddddd),
                      onPressed: () async {
                        sent = true;
                        if (mounted) setState(() {});
                        const url =
                            "https://www.facebook.com/v5.0/dialog/oauth?client_id=${MyGlobals.FACEBOOK_CLIENT_ID}&redirect_uri=${MyGlobals.FACEBOOK_REDIRECT_URI}&scope=email";
                        if (await canLaunch(url)) {
                          await launch(
                            url,
                            forceSafariVC: false,
                            forceWebView: false,
                          );
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Iniciar con',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            "assets/images/logo-facebook.png",
                            width: 22,
                            height: 22,
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => SignupPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Crear cuenta',
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
    );
  }
}
