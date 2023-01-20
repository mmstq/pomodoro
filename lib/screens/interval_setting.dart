import 'package:flutter/material.dart';
import 'package:pomodoro/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Intervals extends StatefulWidget {
  const Intervals({Key? key}) : super(key: key);

  @override
  State<Intervals> createState() => _IntervalsState();
}

class _IntervalsState extends State<Intervals> {
  late double focusTime;
  late double restTime;
  late double longRestTime;
  late bool vibrate;
  late bool autoTimer;
  late double soundValue;
  late final SharedPreferences shared;
  late final TextStyle titleStyle;
  late final TextStyle descriptionStyle;

  void initialise() {
    shared = SharedPrefs.instance;
    titleStyle = const TextStyle(
        fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w400);
    descriptionStyle = titleStyle.copyWith(
        fontSize: 15, color: Colors.white54, fontWeight: FontWeight.w300);
    focusTime = shared.getDouble('focusTime') ?? 25;
    restTime = shared.getDouble('restTime') ?? 5;
    longRestTime = shared.getDouble('longRestTime') ?? 15;
    soundValue = shared.getDouble('soundValue') ?? 5;
    vibrate = shared.getBool('vibrate') ?? true;
    autoTimer = shared.getBool('autoTimer') ?? false;
  }

  Future<bool> save() async {
    var saved = false;
    saved = await shared.setDouble('focusTime', focusTime);
    saved = await shared.setDouble('restTime', restTime);
    saved = await shared.setDouble('longRestTime', longRestTime);
    saved = await shared.setBool('vibrate', vibrate);
    saved = await shared.setBool('autoTimer', autoTimer);
    return saved;
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intervals'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Focus Duration', style: titleStyle),
                  const Spacer(),
                  Text('• ${focusTime.toInt()}      ', style: titleStyle),
                ],
              ),
              Slider(
                  min: 5,
                  label: '${focusTime.toInt()} mins',
                  max: 90,
                  thumbColor: Colors.white,
                  divisions: 17,
                  value: focusTime,
                  onChanged: (value) {
                    setState(() {
                      focusTime = value;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                    'Focus duration of 25 minutes is suggested for best productivity',
                    style: descriptionStyle),
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                children: [
                  Text('Short Rest Duration', style: titleStyle),
                  const Spacer(),
                  Text('• ${restTime.toInt()}      ', style: titleStyle),
                ],
              ),
              Slider(
                  min: 0,
                  label: '${restTime.toInt()} mins',
                  max: 30,
                  thumbColor: Colors.white,
                  divisions: 6,
                  value: restTime,
                  onChanged: (value) {
                    setState(() {
                      restTime = value;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                    'Short break after every focus round. Suggested value is 5 minutes',
                    style: descriptionStyle),
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                children: [
                  Text('Long Rest Duration', style: titleStyle),
                  const Spacer(),
                  Text('• ${longRestTime.toInt()}      ', style: titleStyle),
                ],
              ),
              Slider(
                  min: 5,
                  label: '${longRestTime.toInt()} mins',
                  max: 45,
                  thumbColor: Colors.white,
                  divisions: 8,
                  value: longRestTime,
                  onChanged: (value) {
                    setState(() {
                      longRestTime = value;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                    'Long break after every 4 focus rounds. Suggested value is 15 minutes',
                    style: descriptionStyle),
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                children: [
                  Text('Auto Start Timer', style: titleStyle),
                  const Spacer(),
                  Switch(
                    value: autoTimer,
                    onChanged: (value) {
                      setState(() {
                        autoTimer = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text('Enable Vibration', style: titleStyle),
                  const Spacer(),
                  Switch(
                    value: vibrate,
                    onChanged: (value) {
                      setState(() {
                        vibrate = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Text('Sound Volume Percentage', style: titleStyle),
                  const Spacer(),
                  Text('• ${soundValue.toInt()}      ', style: titleStyle),
                ],
              ),
              Slider(
                  min: 0,
                  label: '${soundValue.toInt()}',
                  max: 10,
                  thumbColor: Colors.white,
                  divisions: 10,
                  value: soundValue,
                  onChanged: (value) {
                    setState(() {
                      soundValue = value;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text('0 = No sound at all', style: descriptionStyle),
              ),
              const SizedBox(
                height: 32,
              ),
              OutlinedButton(
                  onPressed: () async {
                    save().then((value) {
                      if (value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(milliseconds: 1500),
                          content: Text(
                            'Settings saved successfully',
                            style: titleStyle.copyWith(fontSize: 16),
                          ),
                          backgroundColor: Colors.indigo,
                        ));
                      }
                    });
                  },
                  child: const SizedBox(
                      width: 400,
                      height: 50,
                      child: Center(
                        child: Text("Save",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
