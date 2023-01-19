import 'package:pomodoro/model/task_model.dart';

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

