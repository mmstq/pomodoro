import 'package:flutter/material.dart';
import 'package:pomodoro/providers/theme_mode_notifier.dart';
import 'package:provider/provider.dart';

class Appearance extends StatefulWidget {
  const Appearance({Key? key}) : super(key: key);

  @override
  State<Appearance> createState() => _AppearanceState();
}

class _AppearanceState extends State<Appearance> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: theme.appBarTheme.iconTheme!.color,
        ),
        title: const Text('Appearance'),
        backgroundColor: theme.colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.all(32),
        child: Consumer<ThemeNotifier>(
          builder: (context, model, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Choose Theme',
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontSize: 22, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: () => model.changeTheme(0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          'Light',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Spacer(),
                        Radio<int>(
                          value: 0,
                          groupValue: model.themeMode,
                          activeColor: Colors.indigo.shade500,
                          onChanged: (int? value) {
                            model.changeTheme(value!);
                          },
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: () => model.changeTheme(1),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          'Dark',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Spacer(),
                        Radio<int>(
                          value: 1,
                          groupValue: model.themeMode,
                          activeColor: Colors.indigo.shade500,
                          onChanged: (int? value) {
                            model.changeTheme(value!);
                          },
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: () => model.changeTheme(2),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          'System',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Spacer(),
                        Radio<int>(
                          value: 2,
                          groupValue: model.themeMode,
                          activeColor: Colors.indigo.shade500,
                          onChanged: (int? value) {
                            model.changeTheme(value!);
                          },
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                /*Row(
                  children: [
                    Text('Pure Black ',
                        style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    Switch(

                      value: model.blackMode,
                      onChanged: (value) {
                        model.changeBlackMode(value);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 60),
                  child: Text(
                      'This is useful if you device has OLED Display.'
                      ' Pure black color will be used throughout app to save power',
                      style: Theme.of(context).textTheme.displaySmall),
                ),
                const Spacer(),*/
              ],
            );
          },
        ),
      ),
    );
  }
}
