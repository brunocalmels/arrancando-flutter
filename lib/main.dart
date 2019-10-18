import 'package:arrancando/main_scaffold.dart';
import 'package:arrancando/main_scaffold_weird.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arrancando',
      theme: ThemeData(fontFamily: 'Nunito'),
      home: MainScaffold(),
      // home: MainScaffoldWeird(),
    );
  }
}
