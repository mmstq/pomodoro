import 'package:flutter/material.dart';
import 'package:pomodoro/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Behaviour extends StatefulWidget {
  const Behaviour({Key? key}) : super(key: key);

  @override
  State<Behaviour> createState() => _BehaviourState();
}

class _BehaviourState extends State<Behaviour> {
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
    soundValue = shared.getDouble('soundValue') ?? 5;
    vibrate = shared.getBool('vibrate') ?? true;
    autoTimer = shared.getBool('autoTimer') ?? false;
  }

  Future<bool> save() async {
    var saved = false;
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
        title: const Text('Behaviour'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const Spacer(),
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
    );
  }
}
