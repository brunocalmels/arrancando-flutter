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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalSingleton singleton = GlobalSingleton();

  bool sent = false;
  bool _obscurePassword = true;
  // final _touched = false;

  String emailValidator(value) {
    if (value.isEmpty) {
      return 'El campo es obligatorio';
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,1}\.[0-9]{1,1}\.[0-9]{1,1}\.[0-9]{1,1}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{1,}))$';
      // r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      final regex = RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return 'Ingrese un email v??lido';
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

  Future attemptLogin(email, password) async {
    try {
      final resp = await Fetcher.post(
        url: '/authenticate.json',
        unauthenticated: true,
        throwError: true,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (resp.status == 200) {
        return json.decode(resp.body);
      } else {
        print('Login error');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _login(BuildContext buildContext) async {
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
        _scaffoldMessengerKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Error al iniciar sesi??n'),
          ),
        );
      }
      sent = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> _performAppLogin(dynamic body) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'activeUser',
      '${json.encode(body)}',
    );
    context.read<UserState>().setActiveUser(
          ActiveUser.fromJson(body),
        );

    await CategoryWrapper.loadCategories();

    if (prefs.getInt('preferredCiudadId') == null) {
      // int ciudadId = await showDialog(
      //   context: context,
      //   builder: (_) => DialogCategorySelect(
      //     selectCity: true,
      //     titleText: '??Cu??l es tu ciudad?',
      //     allowDismiss: false,
      //   ),
      // );
      final ciudadId = singleton.categories[SectionType.publicaciones]
          ?.where((c) => c.id > 0)
          ?.first
          ?.id;
      if (ciudadId != null) {
        context.read<UserState>().setPreferredCategories(
              SectionType.publicaciones,
              ciudadId,
            );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('preferredCiudadId', ciudadId);
      }
    }

    await ActiveUser.updateUserMetadata(context);

    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => MainScaffold(),
        settings: RouteSettings(name: 'Home'),
      ),
      (_) => false,
    );

    sent = false;
    if (mounted) setState(() {});

    ///
  }

  // Widget _redirectDialog(url) => AlertDialog(
  //       content: RichText(
  //         text: TextSpan(
  //           text:
  //               'Vas a ser redirigido para iniciar sesi??n. Luego de seleccionar tu cuenta, si el sistema te solicita seleccionar una aplicaci??n para continuar, acordate de seleccionar ',
  //           style: Theme.of(context).textTheme.subhead,
  //           children: <TextSpan>[
  //             TextSpan(
  //               text: 'Arrancando',
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: <Widget>[
  //         FlatButton(
  //           child: Text('Continuar'),
  //           onPressed: _touched
  //               ? null
  //               : () async {
  //                   if (mounted)
  //                     setState(() {
  //                       _touched = true;
  //                     });
  //                   if (await canLaunch(url)) {
  //                     await launch(
  //                       url,
  //                       forceSafariVC: false,
  //                       forceWebView: false,
  //                     );
  //                   } else {
  //                     throw 'Could not launch $url';
  //                   }
  //                 },
  //         )
  //       ],
  //     );

  Future<void> _signInApple() async {
    if (await AppleSignIn.isAvailable()) {
      sent = true;
      if (mounted) setState(() {});
      final result = await AppleSignIn.performRequests(
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
            final resp = await Fetcher.post(
              unauthenticated: true,
              url: '/apple-login.json',
              body: {
                'credentials': {
                  'email': result.credential.email,
                  'user': result.credential.user,
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
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No disponible'),
          content: Text(
            'El inicio de sesi??n no est?? disponible para tu dispositivo. Por favor, inici?? sesi??n con usuario y contrase??a.',
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Aceptar'),
            )
          ],
        ),
      );
    }
    sent = false;
    if (mounted) setState(() {});
  }

  void _showLoginErrorSnackbar() {
    _scaffoldMessengerKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          'Ocurri?? un error al iniciar sesi??n, por favor, intent?? nuevamente m??s tarde.',
        ),
      ),
    );
  }

  Future<void> _newSignInGoogle() async {
    sent = true;
    if (mounted) setState(() {});
    try {
      final _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );

      final account = await _googleSignIn.signIn();

      if (account != null) {
        var avatar;
        if (account.photoUrl != null) {
          final response = await http.get(account.photoUrl);
          avatar = base64Encode(response.bodyBytes);
        }

        final resp = await Fetcher.post(
          unauthenticated: true,
          url: '/new-google-login.json',
          body: {
            'credentials': {
              'email': account.email,
              'name': account.displayName,
              'id': account.id,
              if (avatar != null) 'avatar': avatar,
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
    sent = false;
    if (mounted) setState(() {});
  }

  Future<void> _newSignInFacebook() async {
    sent = true;
    if (mounted) setState(() {});
    try {
      final facebookLogin = FacebookLogin();
      final result = await facebookLogin.logIn(['email']);

      if (result != null &&
          result.accessToken != null &&
          result.accessToken.token != null &&
          result.status == FacebookLoginStatus.loggedIn) {
        var graphResponse;
        try {
          graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,picture&access_token=${result.accessToken.token}',
            // 'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${result.accessToken.token}',
          );
        } catch (e) {
          print(e);
        }
        // var email;
        var username;
        var nombre;
        var apellido;
        var imageBytes;
        if (graphResponse != null && graphResponse.body != null) {
          var data = json.decode(graphResponse.body);
          // email = data['email'];
          username = data['name'];
          nombre = data['first_name'];
          apellido = data['last_name'];

          var avatar = data['picture'] != null &&
                  data['picture']['data'] != null &&
                  data['picture']['data']['url'] != null
              ? data['picture']['data']['url']
              : null;
          if (avatar != null) {
            try {
              final response = await http.get(avatar);
              imageBytes = base64Encode(response.bodyBytes);
            } catch (e) {
              print(e);
            }
          }
        }

        final resp = await Fetcher.post(
          unauthenticated: true,
          url: '/new-facebook-login.json',
          body: {
            'credentials': {
              'id': result.accessToken.userId,
              // 'email': email,
              'username': username,
              'nombre': nombre,
              'apellido': apellido,
              'avatar': imageBytes,
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
    sent = false;
    if (mounted) setState(() {});
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
                content: Text('??Quer??s salir?'),
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
          backgroundColor: Theme.of(context).backgroundColor,
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
                        'assets/images/icon.png',
                        width: MediaQuery.of(context).size.width * 0.75,
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      if (Platform.isIOS || Platform.isLinux)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
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
                                        labelText: 'Contrase??a',
                                        hintText: '*********',
                                      ),
                                      validator: (value) =>
                                          requiredValidator(value),
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
                            SizedBox(
                              height: 25,
                            ),
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
                          ],
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

                      if (!Platform.isLinux)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                                        //     'https://accounts.google.com/o/oauth2/auth?client_id=${MyGlobals.GOOGLE_CLIENT_ID}&redirect_uri=${MyGlobals.GOOGLE_REDIRECT_URI}&scope=https://www.googleapis.com/auth/userinfo.email&response_type=code&access_type=offline';

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
                                      'assets/images/logo-google.png',
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
                                        //     'https://www.facebook.com/v5.0/dialog/oauth?client_id=${MyGlobals.FACEBOOK_CLIENT_ID}&redirect_uri=${MyGlobals.FACEBOOK_REDIRECT_URI}&scope=email';

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
                                      'assets/images/logo-facebook.png',
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
                                  // style: ButtonStyle.whiteOutline,
                                  type: ButtonType.signIn,
                                  onPressed: sent ? null : _signInApple,
                                ),
                              ),
                          ],
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
                      //         'https://appleid.apple.com/auth/keys',
                      //         headers: {
                      //           'Content-type': 'application/json',
                      //         },
                      //       );

                      //       print(resp.body);

                      //       String code = json.decode(resp.body)['keys'][0]['n'];

                      //       http.Response respPost = await http.post(
                      //         'https://appleid.apple.com/auth/token',
                      //         headers: {
                      //           'Content-type': 'application/json',
                      //         },
                      //         body: json.encode(
                      //           {
                      //             'cliend_id': '1490590335',
                      //             'client_secret': {
                      //               'header': {
                      //                 'alg': 'ES256',
                      //                 'kid': 'U9P8GN38M5',
                      //               },
                      //               'payload': {
                      //                 // API Key Issuer ID: 5c6e4fe8-d944-41a0-a8f8-9e855116890c
                      //                 'iss': 'CPD2RT3KRV',
                      //                 'iat':
                      //                     DateTime.now().millisecondsSinceEpoch,
                      //                 'exp': DateTime.now()
                      //                     .add(Duration(days: 10))
                      //                     .millisecondsSinceEpoch,
                      //                 'aud': 'https://appleid.apple.com',
                      //                 'sub': 'com.macherit.arrancando',
                      //               },
                      //             },
                      //             'code': code,
                      //             'grant_type': 'authorization_code',
                      //             'redirect_uri': MyGlobals.APPLE_REDIRECT_URI,
                      //           },
                      //         ),
                      //       );

                      //       print(respPost.body);

                      //       // const url =
                      //       //     'https://www.facebook.com/v5.0/dialog/oauth?client_id=${MyGlobals.FACEBOOK_CLIENT_ID}&redirect_uri=${MyGlobals.FACEBOOK_REDIRECT_URI}&scope=email';

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
                      //         //   'assets/images/logo-facebook.png',
                      //         //   width: 27,
                      //         //   height: 27,
                      //         // ),
                      //         Text('A')
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
      ),
    );
  }
}
