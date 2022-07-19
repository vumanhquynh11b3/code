import 'package:flutter/material.dart';
import 'package:vaccine2/routes.dart';
import 'package:vaccine2/screens/splash/splash_screen.dart';
import 'package:vaccine2/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget  {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vaccine',
      theme: theme(),
      home: SplashScreen(),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );


  }

}
