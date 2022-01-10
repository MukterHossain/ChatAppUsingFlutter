import 'package:chatappuf/views/signin.dart';
import 'package:chatappuf/views/signup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isSgnIn = true;
  void toggleView() {
    setState(() {
      isSgnIn = !isSgnIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isSgnIn ? SignIn(toggleView) : SignUp(toggleView);
  }
}
