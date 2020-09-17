import 'package:flutter/material.dart';
import 'package:konkan/pages/auth.dart';
import 'package:konkan/pages/game_screen.dart';
import 'package:konkan/pages/root_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  static bool debugGame = true;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Flutter login demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: debugGame ? GameScreen() : RootPage(),
      ),
    );
  }
}
