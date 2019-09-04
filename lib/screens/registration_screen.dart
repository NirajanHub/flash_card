import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/PaddingButton.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'registrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'flash',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                  //Do something with the user input.
                },
                decoration: kInputStyleText.copyWith(hintText: 'Enter email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                decoration:
                    kInputStyleText.copyWith(hintText: 'Enter password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              PaddingWidget('Register', Colors.blue, () async {
                try {
                  setState(() {
                    showSpinner = true;
                  });
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if (newUser != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                    setState(() {
                      showSpinner = false;
                    });
                  } else {
                    setState(() {
                      showSpinner = false;
                    });
                  }
                } catch (e) {
                  print(e);
                  setState(() {
                    showSpinner = false;
                  });
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
