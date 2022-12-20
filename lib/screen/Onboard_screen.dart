import 'package:attendance_record/main.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  void _hehe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('done_onboarding', true);
    Navigator.of(this.context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return MyHomePage();
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
                      TextButton(onPressed: _hehe, child: Text('Hehhe'))
                    ],
                  ),
                )
            )
        )
    );
  }
}
