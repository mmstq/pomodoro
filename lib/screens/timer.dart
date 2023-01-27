import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:duration_picker/duration_picker.dart';
import 'package:pomodoro/data.dart';
import 'package:pomodoro/model/task_model.dart';
import 'package:pomodoro/providers/timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class Timer extends StatefulWidget {
  const Timer({Key? key}) : super(key: key);

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late AnimationController buttonController;
  late TimerProvider _provider = TimerProvider();

  @override
  void initState() {
    super.initState();
    initiation();
  }

  void initiation() {

    buttonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    controller = AnimationController(
        duration: Duration(seconds: _provider.task.taskDurations![_provider.index].duration!),
        vsync: this);
    final curvedAnimation =
    CurvedAnimation(parent: controller, curve: Curves.linear);
    animation =
    Tween<double>(begin: math.pi * 2, end: 0.0).animate(curvedAnimation)
      ..addListener(() =>
          _provider.recordDurationLeft(controller.lastElapsedDuration!)
      )
      ..addStatusListener((status) {
        onComplete(status);
        if (status == AnimationStatus.completed) {
          _provider.checkVibrationAndMusic();
        }
      });
  }

  void onComplete(AnimationStatus status) {
    if (AnimationStatus.completed == status) {
      if (_provider.task.taskDurations![_provider.index].category == 0) {
        _provider.remaining -= ((_provider.elapsed + _provider.elap) / 1000).round();
      } else {
        _provider.round += 1;
      }
      _provider.elap = 0;
      controller.reset();

      _provider.refreshState();
      _provider.task.taskDurations![_provider.index].isCompleted = true;
      buttonController.reverse();

      if (_provider.index < _provider.task.taskDurations!.length - 1) {
        _provider.index += 1;
      } else {
        _provider.remaining = _provider.task.duration!;
        // _provider.task = _provider.task;
        _provider.round = 1;
        _provider.index = 0;
      }
      controller.duration =
          Duration(seconds: _provider.task.taskDurations![_provider.index].duration!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    final size = MediaQuery
        .of(context)
        .size;
    final theme = Theme.of(context);
    return Consumer<TimerProvider>(
      builder: (builder, model, child) {
        _provider = model;
        return Column(
          children: [
            // Text(model.index.toString()),
            Card(
              color: theme.colorScheme.primaryContainer,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
                          borderRadius: BorderRadius.all(Radius.circular(12))),
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
                          model.task.title!,
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                            'Total: ${model.isRest ? model.remaining : model
                                .remaining - ((model.elapsed + model.elap) ~/
                                1000)} mins',
                            style: theme.textTheme.displaySmall!.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${model.round} / ${model.task.rounds}',
                            style: theme.textTheme.titleSmall),
                        const SizedBox(
                          height: 4,
                        ),
                        Text("${model.task.taskDurations![model.index]
                            .duration} mins",
                            style: theme.textTheme.displaySmall!.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w400)),
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
                      painter: Load(
                          math.pi * 2, Colors.white54.withOpacity(0.03), true),
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
                      /*await showDurationPicker(
                          context: context, initialTime: duration)
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            controller.duration = value;
                          });
                        }
                      });*/
                    },
                    child: Text(
                      model.formattedTime(
                          timeInMilli: controller.duration!.inMilliseconds -
                              model.elapsed -
                              model.elap),
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 36),
              child: Text(
                  '${model.isRest ? 'Take a break for' : 'Stay focused for'}'
                      ' ${model.task.taskDurations![model.index]
                      .duration} minutes',
                  style: theme.textTheme.displaySmall!
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 18)),
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
                                    model.elapsed = 0;
                                    model.elap = 0;
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
                          model.elapsed += model.elap;
                          model.elap = 0;
                          controller.stop(canceled: false);
                          setState(() {
                            buttonController.reverse();
                          });
                        } else {
                          controller.forward();
                          setState(() {
                            buttonController.forward();
                          });
                          // if(model.elapsed!=0) wasPaused=true;
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
                              content: const Text(
                                  'This will switch to next round.'
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
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
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
