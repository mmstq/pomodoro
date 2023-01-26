import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/data.dart';
import 'package:pomodoro/model/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class TimerProvider extends ChangeNotifier {
  late Task _task;
  int elapsed = 0;  // the duration happened during whole session
  int elap = 0;   // the duration happened during single round
  int index = 0;
  int round = 1;
  late int remaining = task.duration!;
  late final SharedPreferences _shared;

  TimerProvider() {
    initiation();
  }

  void initiation() {
    _shared = SharedPrefs.instance;
    initialiseTask();
  }

  void refreshState()=>notifyListeners();


  void recordDurationLeft(Duration? duration){
    elap = duration != null
        ? duration.inMilliseconds
        : elap;
    notifyListeners();
  }

  SharedPreferences get shared => _shared;
  Task get task => _task;

  bool get isRest => task.taskDurations![index].category != 0;

  void initialiseTask() {
    _task = Task();
    _task = Task(
        title: "Default Session",
        rounds: 4,
        duration: ((shared.getDouble('focusTime') ?? 25) * 4).toInt(),
        taskDurations: [
          TaskDurations(
              duration: get('focusTime', 5), isCompleted: false, category: 0),
          TaskDurations(
              duration: get('restTime', 2), isCompleted: false, category: 1),
          TaskDurations(
              duration: get('focusTime', 5), isCompleted: false, category: 0),
          TaskDurations(
              duration: get('restTime', 2), isCompleted: false, category: 1),
          TaskDurations(
              duration: get('focusTime', 5), isCompleted: false, category: 0),
          TaskDurations(
              duration: get('restTime', 2), isCompleted: false, category: 1),
          TaskDurations(
              duration: get('focusTime', 5), isCompleted: false, category: 0),
          TaskDurations(
              duration: get('longRestTime', 3),
              isCompleted: false,
              category: 2),
        ]);
  }

  void checkVibrationAndMusic() {
    if (shared.getBool('vibrate') ?? true) Vibration.vibrate();
    if (shared.getDouble('soundValue') != 0) {
      var audio = AudioPlayer();
      audio.setVolume((shared.getDouble('soundValue') ?? 0.5) / 10);
      audio.play(AssetSource('audio/finish.mp3'));
    }

    /*if (shared.getBool('autoTimer') ?? false) {
                controller.forward();
                setState(() {
                  buttonController.forward();
                });
              }*/
  }

  double calculateTime() {
    return 0;
  }

  void resetTask() {}

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
