import 'package:flutter/material.dart';
import 'package:pomodoro/utils/data.dart';
import 'package:pomodoro/screens/appearance.dart';
import 'package:pomodoro/screens/behaviour.dart';
import 'package:pomodoro/screens/interval_setting.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10)

        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, createRoute(const Intervals()));
              },
              child: Row(
                children: [
                  Text("Intervals",
                      style: theme.textTheme.titleMedium),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.textTheme.displaySmall!.color,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: theme.scaffoldBackgroundColor,
              height: 1,
              width: 300,
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    createRoute(const Behaviour()));
              },
              child: Row(
                children: [
                  Text("Behaviour",
                      style: theme.textTheme.titleMedium),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.textTheme.displaySmall!.color,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: theme.scaffoldBackgroundColor,
              height: 1,
              width: 300,
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    createRoute(const Appearance()));
              },
              child: Row(
                children: [
                  Text("Appearance",
                      style: theme.textTheme.titleMedium),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.textTheme.displaySmall!.color,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
