import 'package:attendance_record/screens/home_screen.dart';
import 'package:attendance_record/screens/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var _doneOnboarding = false;

  void _checkShowOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var doneOnboarding = (prefs.getBool('done_onboarding') ?? false);
    setState(() {
      _doneOnboarding = doneOnboarding;
    });
    await prefs.setBool('done_onboarding', true);
  }

  @override
  void initState() {
    super.initState();
    _checkShowOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: _doneOnboarding ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}


