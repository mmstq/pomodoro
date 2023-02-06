import 'package:flutter/material.dart';
import 'package:pomodoro/utils/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Behaviour extends StatefulWidget {
  const Behaviour({Key? key}) : super(key: key);

  @override
  State<Behaviour> createState() => _BehaviourState();
}

class _BehaviourState extends State<Behaviour> {
  late bool vibrate;
  late bool keepAwake;
  late bool autoTimer;
  late double soundValue;
  late final SharedPreferences shared;

  void initialise() {
    shared = SharedPrefs.instance;
    soundValue = shared.getDouble('soundValue') ?? 5;
    vibrate = shared.getBool('vibrate') ?? true;
    autoTimer = shared.getBool('autoTimer') ?? false;
    keepAwake = shared.getBool('keepAwake') ?? false;
  }

  Future<bool> save() async {
    var saved = false;
    saved = await shared.setBool('vibrate', vibrate);
    saved = await shared.setBool('autoTimer', autoTimer);
    saved = await shared.setBool('keepAwake', keepAwake);
    saved = await shared.setDouble('soundValue', soundValue/10);
    return saved;
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: theme.appBarTheme.iconTheme!.color,),
        title: const Text('Behaviour'),
        backgroundColor: theme.colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Auto Start Timer',
                    style: Theme.of(context).textTheme.titleSmall),
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
                Text('Enable Vibration',
                    style: Theme.of(context).textTheme.titleSmall),
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
              height: 8,
            ),
            Row(
              children: [
                Text('Keep Screen On',
                    style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                Switch(
                  value: keepAwake,
                  onChanged: (value) {
                    setState(() {
                      keepAwake = value;
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
                Text('Sound Volume Percentage',
                    style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                Text('• ${soundValue.toInt()}      ',
                    style: Theme.of(context).textTheme.titleSmall),
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
              child: Text('0 = No sound at all',
                  style: Theme.of(context).textTheme.displaySmall),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () async {
                  save().then((value) {
                    if (value) {
                      shouldKeepAlive = false;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(milliseconds: 1500),
                        content: Text(
                          'Settings saved successfully',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: 16, color: Colors.white),
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
