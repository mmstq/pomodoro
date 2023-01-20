import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:duration_picker/duration_picker.dart';
import 'package:pomodoro/data.dart';
import 'package:pomodoro/model/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class Timer extends StatefulWidget {
  const Timer({Key? key}) : super(key: key);

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Animation<double> animation;
  Task task = defaultTask;
  Duration duration = const Duration(seconds: 20);
  late AnimationController controller;
  late AnimationController buttonController;
  int elapsed = 0;
  int elap = 0;
  int index = 0;
  int round = 1;
  late int remaining = task.duration!;
  late final SharedPreferences shared;

  @override
  void initState() {
    super.initState();
    initiation();
  }

  void initiation() {
    shared = SharedPrefs.instance;
    buttonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    controller = AnimationController(
        duration: Duration(seconds: task.taskDurations![index].duration!),
        vsync: this);
    final curvedAnimation =
        CurvedAnimation(parent: controller, curve: Curves.linear);
    animation =
        Tween<double>(begin: math.pi * 2, end: 0.0).animate(curvedAnimation)
          ..addListener(() {
            setState(() {
              elap = controller.lastElapsedDuration != null
                  ? controller.lastElapsedDuration!.inMilliseconds
                  : elap;
            });
          })
          ..addStatusListener((status) {
            onComplete(status);
            if (status == AnimationStatus.completed) {
              if (shared.getBool('vibrate') ?? true) Vibration.vibrate();
              if (shared.getDouble('soundValue') != 0) {
                AudioPlayer().play(AssetSource('audio/finish.mp3'));

              }
              /*if (shared.getBool('autoTimer') ?? false) {
                controller.forward();
                setState(() {
                  buttonController.forward();
                });
              }*/
            }

          });
  }

  void onComplete(AnimationStatus status) {
    if (AnimationStatus.completed == status) {
      if (task.taskDurations![index].category == 0) {
        remaining -= ((elapsed + elap) / 1000).round();

      }else{
        round += 1;
      }
      elap = 0;
      controller.reset();

      setState(() {
        task.taskDurations![index].isCompleted = true;
        buttonController.reverse();

        if (index < task.taskDurations!.length - 1) {
          index += 1;
        } else {
          remaining = task.duration!;
          task = defaultTask;
          round = 1;
          index = 0;
        }
        controller.duration =
            Duration(seconds: task.taskDurations![index].duration!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final isRest = task.taskDurations![index].category != 0;

    return Column(
      children: [
        // Text(index.toString()),
        Card(
          elevation: 0.2,
          shadowColor: Colors.grey.shade50,
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: const Icon(
                    Icons.access_time_filled,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFDEDEDE),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Focus time: ${isRest ? remaining : remaining - ((elapsed + elap) ~/ 1000)} mins',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white54,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$round / ${task.rounds}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFDEDEDE),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${task.taskDurations![index].duration} mins",
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white54,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 300,
          width: size.width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: CustomPaint(
                  painter:
                      Load(math.pi * 2, Colors.white54.withOpacity(0.03), true),
                ),
              ),
              SizedBox(
                height: 200,
                width: 200,
                child: CustomPaint(
                  painter: Load(animation.value, Colors.red, false),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await showDurationPicker(
                          context: context, initialTime: duration)
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        controller.duration = value;
                      });
                    }
                  });
                },
                child: Text(
                  formattedTime(
                      timeInMilli:
                          controller.duration!.inMilliseconds - elapsed - elap),
                  style: const TextStyle(
                      color: Color(0xFFDEDEDE),
                      fontSize: 35,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 36),
          child: Text(
              '${isRest ? 'Take a break for' : 'Stay focused for'}'
              ' ${task.taskDurations![index].duration} minutes',
              style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFDEDEDE),
                  fontWeight: FontWeight.w500)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 25,
              child: IconButton(
                  icon: const Icon(
                    Icons.restart_alt,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Reset'),
                          content: const Text(
                              'This will reset the current progress and current round.'
                              '\nProgress made in this round will not be counted.\n\nContinue?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                controller.reset();
                                elapsed = 0;
                                elap = 0;
                                Navigator.pop(context);
                              },
                              child: const Text('Yes',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        );
                      },
                    );
                  }),
            ),
            CircleAvatar(
              radius: 40,
              child: IconButton(
                  icon: AnimatedIcon(
                    progress: buttonController,
                    icon: AnimatedIcons.play_pause,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (controller.isAnimating) {
                      elapsed += elap;
                      elap = 0;
                      controller.stop(canceled: false);
                      setState(() {
                        buttonController.reverse();
                      });
                    } else {
                      controller.forward();
                      setState(() {
                        buttonController.forward();
                      });
                      // if(elapsed!=0) wasPaused=true;
                    }
                  }),
            ),
            CircleAvatar(
              radius: 25,
              child: IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Switch'),
                          content: const Text('This will switch to next round.'
                              '\n\nDo you want to add the current round progress?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Dismiss',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            TextButton(
                              onPressed: () {
                                onComplete(AnimationStatus.completed);
                                Navigator.pop(context);
                              },
                              child: const Text('Yes',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        );
                      },
                    );
                  }),
            )
          ],
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

String formattedTime({required int timeInMilli}) {
  int timeInSecond = timeInMilli ~/ 1000;
  int sec = timeInSecond % 60;
  int min = (timeInSecond / 60).floor();
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  return "$minute : $second";
}

class Load extends CustomPainter {
  bool isBackground;
  double arc;
  Color progressColor;

  final gradient = LinearGradient(colors: [
    Colors.blueAccent.withOpacity(1.0),
    Colors.greenAccent.withOpacity(1.0),
  ]);

  Load(this.arc, this.progressColor, this.isBackground);

  @override
  void paint(Canvas canvas, Size size) {
    const rect = Rect.fromLTRB(0, 0, 200, 200);
    const startAngle = -math.pi / 2;
    final sweepAngle = arc;
    const useCenter = false;
    final paint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = isBackground ? 12 : 15;

    if (!isBackground) {
      paint.shader = gradient.createShader(rect);
    }
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
