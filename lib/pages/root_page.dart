import 'package:flutter/material.dart';
import 'package:solitaire/pages/game_screen.dart';
import 'package:solitaire/pages/home_page.dart';

import 'auth.dart';
import 'login.dart';

class RootPage extends StatefulWidget {
  final bool straightToGame;

  const RootPage({Key key, this.straightToGame}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notDetermined;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
//    await auth.signOut();
    auth.currentUser().then((String userId) {
      setState(() {
        authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
      this.build(context);
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
      this.build(context);
    });
  }

  bool _game = false;

  void _playGame() {
    setState(() {
      _game = true;
      this.build(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.straightToGame) {
      return GameScreen();
    } else {
      switch (authStatus) {
        case AuthStatus.notDetermined:
          return _buildWaitingScreen();
        case AuthStatus.notSignedIn:
          return LoginPage(
            onSignedIn: _signedIn,
          );
        case AuthStatus.signedIn:
          if (_game) {
            return GameScreen();
          } else {
            return HomePage(
              onSignedOut: _signedOut,
              playGame: _playGame,
            );
          }
      }
    }
    return null;
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
