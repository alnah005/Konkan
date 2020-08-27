import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LoginPage> {
  var page = LoginOptions();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Padding(
                padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
                child: this.page)));
  }
}

class LoginOptions extends StatefulWidget {
  @override
  _LoginOptionsState createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  var choice;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 50),
            child: Text(
              'KonKan',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
            )),
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
            child: Text(
              'Sign in',
              style: TextStyle(fontSize: 20),
            )),
        Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text(
                'Email',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                EmailLogin();
              },
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.indigo,
                child: Text(
                  'Login with facebook',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
//                            print(nameController.text);
//                            print(passwordController.text);
                },
              )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.redAccent,
                child: Text(
                  'Login with Gmail account',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
//                            print(nameController.text);
//                            print(passwordController.text);
                },
              )),
        ),
        Container(
            child: Padding(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
          child: Column(
            children: <Widget>[
              Text('Don\'t have account?'),
              FlatButton(
                textColor: Colors.blue,
                child: Text(
                  'Sign up',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  //signup screen
                },
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ))
      ],
    );
  }
}

class EmailLogin extends StatefulWidget {
  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'User Name',
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: FlatButton(
            onPressed: () {
              //forgot password screen
            },
            textColor: Colors.blue,
            child: Text('Forgot Password'),
          ),
        ),
      ],
    );
  }
}
