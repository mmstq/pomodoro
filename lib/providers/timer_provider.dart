import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro/utils/data.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

class TimerProvider extends ChangeNotifier {
  // Variables
  int elapsed = 0; // the duration happened during whole session
  int elap = 0; // the duration happened during single round
  int index = 0;
  int round = 1;

  // bool keepAwake = false;
  int totalFocused = 0;
  late double brightness;

  // static const methodChannel = MethodChannel("com.mmstq.pomodoro/method");

  late final SharedPreferences _shared;

  // Getters
  SharedPreferences get shared => _shared;

  TimerProvider() {
    initiation();
  }

  bool get isRest {
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

  void initiation() async {
    _shared = SharedPrefs.instance;
    brightness = await ScreenBrightness().current;

  }

  int getNextRound() {
    var a = 25.0;
    switch (index) {
      case 7:
        a = shared.getDouble('longRestTime') ?? 15.0;
        // a = 2;
        break;

      case 1:
      case 3:
      case 5:
        a = shared.getDouble('restTime') ?? 5.0;
        // a = 1;
        break;

      default:
        a = shared.getDouble('focusTime') ?? 25;
        // a = 3;
        break;
    }
    return a.toInt();
  }

  /* Future<bool> sendMessageToNative({required String methodName, required int minutes}) async{

    try{
      await methodChannel.invokeListMethod(methodName,[minutes]).then((value) {
        print(value);
        return value;

      });
    }on PlatformException catch(e){
      print(e.details);
      return false;
    }
    return false;
  }*/

  void refreshState() => notifyListeners();

  void resetTask() {
    elap = 0;
    elapsed = 0;
    totalFocused = 0;
    round = 1;
    index = 0;
    // sendMessageToNative(methodName: "stopService");
    wakeLockCheck(enable: false);
  }

  void checkVibrationAndMusic() async {
    if (shared.getBool('vibrate') ?? true) Vibration.vibrate();
    if (shared.getDouble('soundValue') != 0) {
      var audio = AudioPlayer();
      audio.setVolume(shared.getDouble('soundValue') ?? 0.5);
      audio.play(AssetSource('audio/finish.mp3'));
    }

    /*if (shared.getBool('autoTimer') ?? false) {
                controller.forward();
                setState(() {
                  buttonController.forward();
                });
              }*/
  }

  void checkLowBrightnessMode({required bool enable}) {
    if (_shared.getBool('lowBrightnessMode') ?? true) {
      if (enable) {
        Future.delayed(const Duration(milliseconds: 500),
            () => ScreenBrightness().setScreenBrightness(0.03));
      } else {
        ScreenBrightness().resetScreenBrightness();
      }
    }
  }

  void wakeLockCheck({required bool enable}) {
    checkLowBrightnessMode(enable: enable);
    if (enable) {
      Future.delayed(const Duration(milliseconds: 300),()=>Wakelock.enable());
    } else {
      Wakelock.disable();
    }
  }

  String formattedTime({required int timeInMilli}) {
    int timeInSecond = timeInMilli ~/ 1000;
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  @override
  void dispose() {
    wakeLockCheck(enable: false);
    super.dispose();
  }
}
