import 'package:flutter/material.dart';
import 'package:pomodoro/model/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool shouldKeepAlive = true;

Route createRoute(Widget newPage) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondAnimation) => newPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.1, 0.0);
        const end = Offset.zero;
        const curve  = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween),child: child,);
      });
}


int get(String key, int defaultValue){
  /*if (shared.containsKey(key)) {
    return shared.getDouble(key)!.toInt();
  }*/
  return defaultValue;
}

class SharedPrefs {
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();
}