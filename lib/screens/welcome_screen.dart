import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/PaddingButton.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  Animation animation2;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(seconds: 3), vsync: this, upperBound: 1);
    animationController.forward();
    // animationController.reverse(from:1);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.decelerate);
    animation.addListener(() {
      setState(() {});
      print(animation.value * 100);
    });
    animationController.addListener(() {
      setState(() {});
      print(animationController.value);
    });

    animation2 = ColorTween(begin: Colors.red, end: Colors.blue)
        .animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   backgroundColor: Colors.red.withOpacity(animationController.value),
      backgroundColor: animation2.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'flash',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation.value * 100,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['${(animation.value * 100).round()}%'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            PaddingWidget('Login', Colors.lightBlueAccent, () {
              Navigator.pushNamed(context, LoginScreen.id);
            }),
            PaddingWidget('Register', Colors.lightBlueAccent, () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}
