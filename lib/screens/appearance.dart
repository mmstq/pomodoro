import 'package:flutter/material.dart';
import 'package:pomodoro/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appearance extends StatefulWidget {
  const Appearance({Key? key}) : super(key: key);

  @override
  State<Appearance> createState() => _AppearanceState();
}

class _AppearanceState extends State<Appearance> {
  late bool vibrate;
  late bool autoTimer;
  late double soundValue;
  late final SharedPreferences shared;
  late final TextStyle titleStyle;
  late final TextStyle descriptionStyle;
  Mode _mode = Mode.dark;

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
        title: const Text('Appearance'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
              ListTile(
                  title: const Text('Mac'),
                  trailing: Radio<Mode>(
                    value: Mode.light,
                    groupValue: _mode,
                    onChanged: (Mode? value) {
                      setState(() {
                        _mode = value!;
                      });
                    },
                  )
              ),
              ListTile(
                  title: const Text('Windows'),
                  trailing: Radio<Mode>(
                    value: Mode.dark,
                    groupValue: _mode,
                    onChanged: (Mode? value) {
                      setState(() {
                        _mode = value!;
                      });
                    },
                  )
              ),
              ListTile(
                  title: const Text('Linux'),
                  trailing: Radio<Mode>(
                    value: Mode.system,
                    groupValue: _mode,
                    onChanged: (Mode? value) {
                      setState(() {
                        _mode = value!;
                      });
                    },
                  )
              ),
            ],),
            const SizedBox(
              height: 8,
            ),
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
