import 'package:flutter/material.dart';

class DevLogin extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function login;

  DevLogin({
    this.emailController,
    this.passwordController,
    this.login,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Builder(
          // NECESITA EL CONTEXT PARA EL SNACKBAR
          builder: (context) => FlatButton(
            onPressed: () {
              emailController.text = "i@m.c";
              passwordController.text = "123456";
              login(context);
            },
            child: Text(
              'i@m.c',
            ),
          ),
        ),
        Builder(
          // NECESITA EL CONTEXT PARA EL SNACKBAR
          builder: (context) => FlatButton(
            onPressed: () {
              emailController.text = "b@m.c";
              passwordController.text = "123456";
              login(context);
            },
            child: Text(
              'b@m.c',
            ),
          ),
        ),
      ],
    );
  }
}
