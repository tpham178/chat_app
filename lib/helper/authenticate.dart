import 'package:chat_app/views/signin.dart';
import 'package:chat_app/views/signup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;

    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignIn(toggle: toggleView,);
    }else{
      return SignUp(toggle: toggleView,);
    };
  }
}
