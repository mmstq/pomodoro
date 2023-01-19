import 'package:pomodoro/model/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final defaultTask = Task(title: "Default Session", rounds: 4,duration: 20, taskDurations: [
  TaskDurations(duration: 5, isCompleted: false, category: 0),
  TaskDurations(duration: 2, isCompleted: false, category: 1),
  TaskDurations(duration: 5, isCompleted: false, category: 0),
  TaskDurations(duration: 2, isCompleted: false, category: 1),
  TaskDurations(duration: 5, isCompleted: false, category: 0),
  TaskDurations(duration: 2, isCompleted: false, category: 1),
  TaskDurations(duration: 5, isCompleted: false, category: 0),
  TaskDurations(duration: 3, isCompleted: false, category: 2),
]);

class SharedPrefs {
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();
}