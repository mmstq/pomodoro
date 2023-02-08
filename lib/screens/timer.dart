import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'dart:math' as math;
import 'package:pomodoro/providers/timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

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
  TimerProvider _provider = TimerProvider();

  @override
  void initState() {
    super.initState();
    initiation();
  }


  void initiation() {
    buttonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    controller = AnimationController(
        duration: Duration(minutes: _provider.getNextRound()), vsync: this);
    final curvedAnimation =
        CurvedAnimation(parent: controller, curve: Curves.linear);
    animation =
        Tween<double>(begin: math.pi * 2, end: 0.0).animate(curvedAnimation)
          ..addListener(() {
            _provider.elap = controller.lastElapsedDuration != null
                ? controller.lastElapsedDuration!.inMilliseconds
                : _provider.elap;
            _provider.refreshState();
          })
          ..addStatusListener((status) {
            onComplete(status);
            if (status == AnimationStatus.completed) {
              _provider.sendMessageToNative(methodName: "stopService");
              Wakelock.disable();
              _provider.checkVibrationAndMusic();
            }else if(status == AnimationStatus.forward){
              print("start");
              _provider.sendMessageToNative(methodName: "startService");
              /*FlutterBackground.initialize();
              FlutterBackground.enableBackgroundExecution();*/

            }
          });
  }

  void onComplete(AnimationStatus status) {
    if (AnimationStatus.completed == status) {
      if (!_provider
          .isRest /*_provider.task.taskDurations![_provider.index].category == 0*/) {
        _provider.totalFocused +=
            ((_provider.elapsed + _provider.elap) / 60000).round();
      } else {
        _provider.round += 1;
      }
      _provider.elap = 0;
      _provider.elapsed = 0;

      // _provider.task.taskDurations![_provider.index].isCompleted = true;

      controller.reset();
      buttonController.reverse();

      if (_provider.index < 7) {
        _provider.index += 1;
      } else {
        // _provider.calculateRemaining();
        _provider.round = 1;
        _provider.index = 0;
        _provider.resetTask();
      }

      // controller.duration = Duration(minutes: _provider.getNextRound());
    }else if(AnimationStatus.reverse == status){
      _provider.resetTask();
    }

    controller.duration = Duration(minutes: _provider.getNextRound());
    _provider.refreshState();
    _provider.wakeLockCheck(enable: false);

  }

  @override
  Widget build(BuildContext   context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
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
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                          'Total focused time',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                            '${model.isRest ? model.totalFocused : model.totalFocused + ((model.elapsed + model.elap) ~/ 60000)} mins',
                            style: theme.textTheme.displaySmall!.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Round', style: theme.textTheme.titleSmall),
                        const SizedBox(
                          height: 4,
                        ),
                        Text("${model.round} / 4",
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
                  Text(
                    model.formattedTime(
                        timeInMilli: controller.duration!.inMilliseconds -
                            model.elapsed -
                            model.elap),
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 36),
              child: Text(
                  '${model.isRest ? 'Take a break for' : 'Stay focused for'}'
                  ' ${model.getNextRound()} minutes',
                  style: theme.textTheme.displaySmall!
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 18)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 25,
                  child: IconButton(
                      splashRadius: 25,
                      icon: Icon(
                        Icons.restart_alt,
                        color: theme.colorScheme.tertiary,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              contentPadding: const EdgeInsets.all(24),
                              surfaceTintColor:
                                  theme.scaffoldBackgroundColor,
                              title: const Text('Reset'),
                              titleTextStyle: theme.textTheme.titleLarge!
                                .copyWith(
                            fontWeight: FontWeight.w800,
                                fontSize: 32),
                              children: [
                                Text(
                                    'This will reset the whole session.'
                                        '\n\nProgress made in this round will not be counted.\n\nContinue?', style: theme.textTheme.titleSmall,),
                                const SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green)),
                                      onPressed: () {
                                        controller.reset();
                                        buttonController.reverse();
                                        onComplete(AnimationStatus.reverse);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Yes',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 20,),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),),side: const BorderSide(
                                          color: Colors.red,
                                          width: 1.5)),
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
                                )
                              ],
                            );
                          },
                        );
                      }),
                ),
                CircleAvatar(
                  radius: 40,
                  child: IconButton(
                      splashRadius: 80,
                      icon: AnimatedIcon(
                        size: 40,
                        progress: buttonController,
                        icon: AnimatedIcons.play_pause,
                        color: theme.colorScheme.tertiary,
                      ),
                      onPressed: () {
                        if (controller.isAnimating) {
                          model.wakeLockCheck(enable: false);
                          model.elapsed += model.elap;
                          model.elap = 0;
                          controller.stop(canceled: false);
                          buttonController.reverse();
                        } else {
                          model.wakeLockCheck(enable: true);
                          controller.forward();
                          buttonController.forward();
                        }
                        model.refreshState();
                      }),
                ),
                CircleAvatar(
                  radius: 25,
                  child: IconButton(
                      icon: Icon(
                        Icons.skip_next,
                        color: theme.colorScheme.tertiary,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              contentPadding: const EdgeInsets.all(24),
                              surfaceTintColor:
                                  theme.colorScheme.primaryContainer,
                              title: const Text('Switch'),
                              titleTextStyle: theme.textTheme.titleLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 32),
                              children: [
                                Text(
                                  'This will switch to next round.'
                                  '\n\nDo you want to add the current round progress?',
                                  style: theme.textTheme.titleSmall,
                                ),
                                const SizedBox(height: 20,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green)),
                                      onPressed: () {
                                        onComplete(AnimationStatus.completed);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Yes',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),),side: const BorderSide(
                                          color: Colors.red,
                                          width: 1.5)),
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
                                )
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
  void dispose() async {
    _provider.wakeLockCheck(enable: false);
    // FlutterBackground.disableBackgroundExecution();
    super.dispose();
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
