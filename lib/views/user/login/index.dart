import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/user.dart';
// import 'package:arrancando/views/home/app_bar/_dialog_category_select.dart';
import 'package:arrancando/views/home/index.dart';
import 'package:arrancando/views/user/login/_dev_login.dart';
import 'package:arrancando/views/user/signup/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final GlobalSingleton singleton = GlobalSingleton();

  bool sent = false;
  bool _obscurePassword = true;
  bool _touched = false;

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
      if (body != null && body['auth_token'] != null) {
        await _performAppLogin(body);
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

  _performAppLogin(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'activeUser',
      "${json.encode(body)}",
    );
    Provider.of<UserState>(context, listen: false).setActiveUser(
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
          ?.where((c) => c.id > 0)
          ?.first
          ?.id;
      if (ciudadId != null) {
        Provider.of<UserState>(context, listen: false).setPreferredCategories(
          SectionType.publicaciones,
          ciudadId,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("preferredCiudadId", ciudadId);
      }
    }

    ActiveUser.updateUserMetadata(context);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => MainScaffold(),
        settings: RouteSettings(name: 'Home'),
      ),
      (_) => false,
    );

    if (mounted)
      setState(() {
        sent = false;
      });

    ///
  }

  _redirectDialog(url) => AlertDialog(
        content: RichText(
          text: TextSpan(
            text:
                'Vas a ser redirigido para iniciar sesión. Luego de seleccionar tu cuenta, si el sistema te solicita seleccionar una aplicación para continuar, acordate de seleccionar ',
            style: Theme.of(context).textTheme.subhead,
            children: <TextSpan>[
              TextSpan(
                text: '"Arrancando"',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Continuar'),
            onPressed: _touched
                ? null
                : () async {
                    if (mounted)
                      setState(() {
                        _touched = true;
                      });
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
          )
        ],
      );

  _signInApple() async {
    if (await AppleSignIn.isAvailable()) {
      if (mounted)
        setState(() {
          sent = true;
        });
      final AuthorizationResult result = await AppleSignIn.performRequests(
        [
          AppleIdRequest(
            requestedScopes: [
              Scope.email,
            ],
          ),
        ],
      );
      if (result != null) {
        switch (result.status) {
          case AuthorizationStatus.authorized:
            ResponseObject resp = await Fetcher.post(
              unauthenticated: true,
              url: "/apple-login.json",
              body: {
                "credentials": {
                  "email": result.credential.email,
                  "user": result.credential.user,
                }
              },
            );
            if (resp != null &&
                resp.body != null &&
                resp.status != null &&
                resp.status == 200) {
              await _performAppLogin(json.decode(resp.body));
            } else {
              _showLoginErrorSnackbar();
            }
            break;
          default:
            _showLoginErrorSnackbar();
            break;
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("No disponible"),
          content: Text(
            "El inicio de sesión no está disponible para tu dispositivo. Por favor, iniciá sesión con usuario y contraseña.",
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Aceptar"),
            )
          ],
        ),
      );
    }
    if (mounted)
      setState(() {
        sent = false;
      });
  }

  _showLoginErrorSnackbar() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          "Ocurrió un error al iniciar sesión, por favor, intentá nuevamente más tarde.",
        ),
      ),
    );
  }

  _newSignInGoogle() async {
    if (mounted)
      setState(() {
        sent = true;
      });
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );

      GoogleSignInAccount account = await _googleSignIn.signIn();

      if (account != null) {
        ResponseObject resp = await Fetcher.post(
          unauthenticated: true,
          url: "/new-google-login.json",
          body: {
            "credentials": {
              "email": account.email,
              "name": account.displayName,
              "id": account.id,
            }
          },
        );
        if (resp != null &&
            resp.body != null &&
            resp.status != null &&
            resp.status == 200) {
          await _performAppLogin(json.decode(resp.body));
        } else {
          _showLoginErrorSnackbar();
        }
      } else {
        _showLoginErrorSnackbar();
      }
    } catch (e) {
      _showLoginErrorSnackbar();
    }
    if (mounted)
      setState(() {
        sent = false;
      });
  }

  _newSignInFacebook() async {
    if (mounted)
      setState(() {
        sent = true;
      });
    try {
      final facebookLogin = FacebookLogin();
      final result = await facebookLogin.logIn(['email']);

      if (result != null &&
          result.accessToken != null &&
          result.accessToken.token != null &&
          result.status == FacebookLoginStatus.loggedIn) {
        ResponseObject resp = await Fetcher.post(
          unauthenticated: true,
          url: "/new-facebook-login.json",
          body: {
            "credentials": {
              "id": result.accessToken.userId,
            }
          },
        );
        if (resp != null &&
            resp.body != null &&
            resp.status != null &&
            resp.status == 200) {
          await _performAppLogin(json.decode(resp.body));
        } else {
          _showLoginErrorSnackbar();
        }
      } else {
        _showLoginErrorSnackbar();
      }
    } catch (e) {
      _showLoginErrorSnackbar();
    }
    if (mounted)
      setState(() {
        sent = false;
      });
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
        backgroundColor: Theme.of(context).backgroundColor,
        key: _scaffoldKey,
        body: Center(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // SizedBox(
                    //   height: 35,
                    // ),
                    Image.asset(
                      "assets/images/icon.png",
                      width: MediaQuery.of(context).size.width * 0.75,
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    if (Platform.isIOS)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: new InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        ],
                      ),
                    if (Platform.isIOS)
                      SizedBox(
                        height: 25,
                      ),
                    if (Platform.isIOS)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Builder(
                          // NECESITA EL CONTEXT PARA EL SNACKBAR
                          builder: (context) => RaisedButton(
                            onPressed: sent
                                ? null
                                : () {
                                    _login(context);
                                  },
                            child: Text(
                              'Login',
                            ),
                          ),
                        ),
                      ),

                    if (MyGlobals.SHOW_DEV_LOGIN)
                      DevLogin(
                        emailController: emailController,
                        passwordController: passwordController,
                        login: _login,
                      ),
                    if (!Platform.isIOS)
                      SizedBox(
                        height: 25,
                      ),
                    ButtonTheme(
                      minWidth: Platform.isIOS ? 230 : 150,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        onPressed: sent
                            ? null
                            : () {
                                // sent = true;
                                // if (mounted) setState(() {});
                                // const url =
                                //     "https://accounts.google.com/o/oauth2/auth?client_id=${MyGlobals.GOOGLE_CLIENT_ID}&redirect_uri=${MyGlobals.GOOGLE_REDIRECT_URI}&scope=https://www.googleapis.com/auth/userinfo.email&response_type=code&access_type=offline";

                                // showDialog(
                                //   context: context,
                                //   builder: (_) => _redirectDialog(url),
                                // );

                                _newSignInGoogle();
                              },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'INICIAR CON',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              "assets/images/logo-google.png",
                              width: 27,
                              height: 27,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    // Comento hasta que se solucione login con Facebook
                    // if (!Platform.isIOS)
                    ButtonTheme(
                      minWidth: Platform.isIOS ? 230 : 150,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        onPressed: sent
                            ? null
                            : () {
                                // sent = true;
                                // if (mounted) setState(() {});
                                // const url =
                                //     "https://www.facebook.com/v5.0/dialog/oauth?client_id=${MyGlobals.FACEBOOK_CLIENT_ID}&redirect_uri=${MyGlobals.FACEBOOK_REDIRECT_URI}&scope=email";

                                // showDialog(
                                //   context: context,
                                //   builder: (_) => _redirectDialog(url),
                                // );
                                _newSignInFacebook();
                              },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'INICIAR CON',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              "assets/images/logo-facebook.png",
                              width: 27,
                              height: 27,
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (Platform.isIOS)
                      Container(
                        width: 250,
                        padding: const EdgeInsets.all(7),
                        child: AppleSignInButton(
                          style: ButtonStyle.whiteOutline,
                          type: ButtonType.signIn,
                          onPressed: sent ? null : _signInApple,
                        ),
                      ),

                    // if (!Platform.isIOS)
                    // ButtonTheme(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 30,
                    //     vertical: 10,
                    //   ),
                    //   child: RaisedButton(
                    //     color: Theme.of(context).accentColor,
                    //     onPressed: () async {
                    //       sent = true;
                    //       if (mounted) setState(() {});

                    //       http.Response resp = await http.get(
                    //         "https://appleid.apple.com/auth/keys",
                    //         headers: {
                    //           "Content-type": "application/json",
                    //         },
                    //       );

                    //       print(resp.body);

                    //       String code = json.decode(resp.body)['keys'][0]['n'];

                    //       http.Response respPost = await http.post(
                    //         "https://appleid.apple.com/auth/token",
                    //         headers: {
                    //           "Content-type": "application/json",
                    //         },
                    //         body: json.encode(
                    //           {
                    //             "cliend_id": "1490590335",
                    //             "client_secret": {
                    //               "header": {
                    //                 "alg": "ES256",
                    //                 "kid": "U9P8GN38M5",
                    //               },
                    //               "payload": {
                    //                 // API Key Issuer ID: 5c6e4fe8-d944-41a0-a8f8-9e855116890c
                    //                 "iss": "CPD2RT3KRV",
                    //                 "iat":
                    //                     DateTime.now().millisecondsSinceEpoch,
                    //                 "exp": DateTime.now()
                    //                     .add(Duration(days: 10))
                    //                     .millisecondsSinceEpoch,
                    //                 "aud": "https://appleid.apple.com",
                    //                 "sub": "com.macherit.arrancando",
                    //               },
                    //             },
                    //             "code": code,
                    //             "grant_type": 'authorization_code',
                    //             "redirect_uri": MyGlobals.APPLE_REDIRECT_URI,
                    //           },
                    //         ),
                    //       );

                    //       print(respPost.body);

                    //       // const url =
                    //       //     "https://www.facebook.com/v5.0/dialog/oauth?client_id=${MyGlobals.FACEBOOK_CLIENT_ID}&redirect_uri=${MyGlobals.FACEBOOK_REDIRECT_URI}&scope=email";

                    //       // showDialog(
                    //       //   context: context,
                    //       //   builder: (_) => _redirectDialog(url),
                    //       // );
                    //     },
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: <Widget>[
                    //         Text(
                    //           'INICIAR CON',
                    //           style: TextStyle(color: Colors.black),
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         // Image.asset(
                    //         //   "assets/images/logo-facebook.png",
                    //         //   width: 27,
                    //         //   height: 27,
                    //         // ),
                    //         Text("A")
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    // if (Platform.isIOS)
                    //   FlatButton(
                    //     onPressed: () {
                    //       Navigator.of(context).pushReplacement(
                    //         MaterialPageRoute(
                    //           builder: (_) => SignupPage(),
                    //         ),
                    //       );
                    //     },
                    //     child: Text(
                    //       'Crear cuenta',
                    //     ),
                    //   ),

                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: SizedBox(
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
