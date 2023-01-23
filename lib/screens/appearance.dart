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
        margin: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
                title: Text('Light',style: titleStyle,),
                trailing: Radio<Mode>(
                  value: Mode.light,
                  groupValue: _mode,
                  activeColor: Colors.indigo.shade500,
                  onChanged: (Mode? value) {
                    setState(() {
                      _mode = value!;
                      ThemeData.light();
                    });
                  },
                )
            ),
            ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Dark', style: titleStyle,),
                trailing: Radio<Mode>(
                  value: Mode.dark,
                  activeColor: Colors.indigo.shade500,
                  groupValue: _mode,
                  onChanged: (Mode? value) {
                    setState(() {
                      _mode = value!;
                    });
                  },
                )
            ),
            ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('System',style:titleStyle),
                trailing: Radio<Mode>(
                  value: Mode.system,
                  activeColor: Colors.indigo.shade500,
                  groupValue: _mode,
                  onChanged: (Mode? value) {
                    setState(() {
                      _mode = value!;
                    });
                  },
                )
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text('Pure Black ', style: titleStyle),
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
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Text(
                  'Long break after every 4 focus rounds. Suggested value is 15 minutes',
                  style: descriptionStyle),
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
