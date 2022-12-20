import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  void _updatePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('done_onboarding', true);
    Navigator.of(this.context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return HomeScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: SafeArea(
                child:Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Hello Guys !!!', style: TextStyle(fontSize: 40),),
                      TextButton(onPressed: _updatePreferences, child: Text('Hehhe'))
                    ],
                  ),
                )
            )
        )
    );
  }
}
