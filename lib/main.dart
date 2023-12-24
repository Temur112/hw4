import 'package:flutter/material.dart';
import 'package:hw4/SecondScreen.dart';
import 'package:hw4/thirdScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: "/",
      home: SplashScreen(),
      // routes: {
      //   "/": (context) => SplashScreen(),
      //   "/second": (context) => SecondScreen(),
      //   "/third": (context) => ThirdScreen()
      // },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showWelcomeScreen = false;

  @override
  void initState() {
    super.initState();
    checkIfFirstTime();
  }

  void checkIfFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('firstTime') ?? true;

    if (isFirstTime) {
      // If it's the first time, show the welcome screen/tutorial
      setState(() {
        _showWelcomeScreen = true;
      });
      prefs.setBool(
          'firstTime', false); // Update to indicate not the first time anymore
    } else {
      // If not the first time, proceed to the main screen or any other screen
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showWelcomeScreen ? WelcomeScreen() : Container(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the App!',
              style: TextStyle(fontSize: 24),
            ),
            // Add your tutorial content here
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('This is the main screen.'),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 300),
                        pageBuilder: (_, __, ___) => SecondScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        }));
              },
              child: const Text("Go"))
        ],
      )),
    );
  }
}
