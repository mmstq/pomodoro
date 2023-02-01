import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/utils/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

class TimerProvider extends ChangeNotifier {
  // Variables
  int elapsed = 0; // the duration happened during whole session
  int elap = 0; // the duration happened during single round
  int index = 0;
  int round = 1;
  bool keepAwake = false;

  int totalFocused=0;
  late final SharedPreferences _shared;

  // Getters
  SharedPreferences get shared => _shared;


  bool get isRest  {
    switch (index) {
      case 1:
      case 3:
      case 5:
      case 7:
        return true;
      default:
        return false;
  }
}

  TimerProvider() {
    initiation();
  }


  void initiation() {
    _shared = SharedPrefs.instance;
    keepAwake = _shared.getBool('keepAwake')??false;
  }

  int getNextRound() {

    var a = 25.0;
    switch (index) {

      case 7:
        a = shared.getDouble('longRestTime') ?? 15.0;
        break;

      case 1:
      case 3:
      case 5:
        a = shared.getDouble('restTime') ?? 5.0;
        break;

      default:
        a = shared.getDouble('focusTime') ?? 25;
        break;
    }
    return a.toInt();
  }


  void checkVibrationAndMusic() {
    if (shared.getBool('vibrate') ?? true) Vibration.vibrate();
    if (shared.getDouble('soundValue') != 0) {
      var audio = AudioPlayer();
      audio.setVolume(shared.getDouble('soundValue') ?? 5);
      audio.play(AssetSource('audio/finish.mp3'));
    }

    /*if (shared.getBool('autoTimer') ?? false) {
                controller.forward();
                setState(() {
                  buttonController.forward();
                });
              }*/
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }



  void refreshState() => notifyListeners();


  void resetTask() {
    elap = 0;
    elapsed = 0;
    totalFocused = 0;
    round = 1;
    index = 0;
  }

  int get(String key, int defaultValue) {
    /*if (shared.containsKey(key)) {
    return shared.getDouble(key)!.toInt();
  }*/
    return defaultValue;
  }

  String formattedTime({required int timeInMilli}) {
    int timeInSecond = timeInMilli ~/ 1000;
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }
}
