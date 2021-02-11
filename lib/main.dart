import 'package:flutter/material.dart';
import 'Screens/FavoriteScreen.dart';
import 'Screens/SignInScreen.dart';
import 'Screens/SignUPScreen.dart';
import 'Screens/HomeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up Screen ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => SignInScreen(),
        '/SignUpScreen': (context) => SignUpScreen(),
        '/HomeScreen': (context) => HomeScreen(),
        '/FavoriteScreen': (context) => FavoriteScreen(),
      },
    );
  }
}
