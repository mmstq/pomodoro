import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/homepage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {//maven baloo2 rajdhani sairaSemiCondensed itim coda
    return MaterialApp(
      title: 'Flutter Demo',

      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        fontFamily: "Sofia",
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Ubuntu',
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}


