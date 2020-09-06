import 'package:flutter/material.dart';

import 'auth.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onSignedOut;
  final VoidCallback playGame;
  const HomePage({this.onSignedOut, this.playGame});

  Future<void> _signOut(BuildContext context) async {
    print("so2");
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
      print("e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: <Widget>[
          FlatButton(
            child: Text("Play game",
                style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () => playGame(),
          ),
          FlatButton(
            child: Text('Logout',
                style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Container(
        child: Center(child: Text('Welcome', style: TextStyle(fontSize: 32.0))),
      ),
    );
  }
}
