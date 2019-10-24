import 'package:arrancando/views/home/index.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arrancando',
      theme: ThemeData(
        fontFamily: 'Nunito',
        primaryColor: Color(0xff446622),
        accentColor: Color(0xffeab01e),
      ),
      home: MainScaffold(),
    );
  }
}
