import 'package:flutter/material.dart';
import 'package:pomodoro/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier{

  ThemeNotifier(){
    initialise();
  }

  late int _themeMode;
  late bool _blackModel;
  late final SharedPreferences _shared;

  SharedPreferences get shared => _shared;
  int get themeMode => _themeMode;
  bool get blackMode => _blackModel;

  void initialise() {
    _shared = SharedPrefs.instance;
    _themeMode = _shared.getInt('themeMode') ?? 0;
    _blackModel = _shared.getBool('blackThemeMode') ?? false;
  }

  void changeTheme(int theme){
    _themeMode = theme;
    _shared.setInt('themeMode', _themeMode);
    notifyListeners();
  }

  void changeBlackMode(bool value){
    _blackModel = value;
    _shared.setBool('blackThemeMode', _blackModel);
    notifyListeners();

  }


}