
class Task {
  String? title;
  List<TaskDurations>? taskDurations;
  int? rounds;
  int? duration;
  String? image;

  Task({this.title, this.taskDurations,this.rounds, this.duration, this.image});

  Task.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['taskDurations'] != null) {
      taskDurations = <TaskDurations>[];
      json['taskDurations'].forEach((v) {
        taskDurations!.add(TaskDurations.fromJson(v));
      });
    }
    duration = json['duration'];
    rounds = json['rounds'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (taskDurations != null) {
      data['taskDurations'] =
          taskDurations!.map((v) => v.toJson()).toList();
    }
    data['duration'] = duration;
    data['image'] = image;
    data['rounds'] = rounds;
    return data;
  }
}

class TaskDurations {
  int? duration;
  bool? isCompleted;
  int? category;

  TaskDurations({this.duration, this.isCompleted, this.category});

  TaskDurations.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    isCompleted = json['isCompleted'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['duration'] = duration;
    data['isCompleted'] = isCompleted;
    data['category'] = category;
    return data;
  }
}
