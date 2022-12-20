import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
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
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return const HomeScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: IntroductionScreen(
              scrollPhysics: const BouncingScrollPhysics(), //Default is BouncingScrollPhysics
              pages:  [
                PageViewModel(
                  title: 'Welcome to Attendance Record App',
                  body: 'Here is overview how this app works',
                  image: Center(
                    child: Image.asset('assets/images/overview.png'),
                  )
                ),
                PageViewModel(
                  title: 'Detail Cards Info',
                  body: 'Show details of User Attendance',
                  image: Center(
                    child: Image.asset('assets/images/card_details.png'),
                  )
                ),
                PageViewModel(
                  title: 'Add new user',
                  body: 'Add new attendance list user',
                    image: Center(
                      child: Image.asset('assets/images/add_user.png'),
                    )
                ),
                PageViewModel(
                    title: 'Share contact phone',
                    body: 'Share contact details to another app',
                    image: Center(
                      child: Image.asset('assets/images/share.png'),
                    )
                ),
                PageViewModel(
                    title: 'Search User',
                    body: 'Search User based on name',
                    image: Center(
                      child: Image.asset('assets/images/search_user.png'),
                    )
                ),
              ],
              rawPages: const [
                //If you don't want to use PageViewModel you can use this
              ],
              //If you provide both rawPages and pages parameter, pages will be used.
              onChange: (e){
                // When something changes
              },
              onDone: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()
                    )
                );
                // When done button is press
              },
              onSkip: () {
                // You can also override onSkip callback
              },
              showSkipButton: true, //Is the skip button should be display
              skip: const Icon(Icons.skip_next),
              next: const Icon(Icons.forward),
              done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),

              dotsDecorator: DotsDecorator(
                  size: const Size.square(10.0),
                  activeSize: const Size(20.0, 10.0),
                  activeColor: Theme.of(context).progressIndicatorTheme.color,
                  color: Colors.black26,
                  spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0))),
            ),
        )
    );
  }
}
