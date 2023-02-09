import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pomodoro/screens/privacy_policy.dart';
import 'package:pomodoro/screens/settings.dart';
import 'package:pomodoro/screens/timer.dart';
import 'package:pomodoro/utils/data.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController pageController = PageController();
  int index = 0;
  final List<String> title = ['Focus', /*'Tasks', 'Analytics',*/ 'Settings'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    FlutterNativeSplash.remove();
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    /*PopupMenuItem<String>(
                      onTap: () => Future(()=>Navigator.push(context, createRoute(const About()))),
                      child: Text(
                        'About       ',
                        style: theme.textTheme.titleSmall,
                      ),
                    ),*/
                    PopupMenuItem<String>(
                      onTap: ()=>
                      Future(()=>Navigator.push(context, createRoute(const Privacy()))),
                      child: Text(
                        'Privacy Policy',
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                  ])
        ],
        elevation: 0,
        backgroundColor: theme.colorScheme.primaryContainer,
        title: Text(
          title[index],
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [
          Timer(),
          /*TaskPage(),
          Analytics(),*/
          Setting(),
        ],
      ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: theme.colorScheme.primaryContainer,
        onButtonPressed: (i) {
          setState(() {
            index = i;
          });
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuad);
        },
        iconSize: 25,
        inactiveColor: theme.bottomNavigationBarTheme.unselectedItemColor,
        activeColor: theme.bottomNavigationBarTheme.selectedItemColor!,
        selectedIndex: index,
        barItems: [
          BarItem(
            icon: Icons.timelapse_rounded,
            title: 'Timer',
          ),
          /* BarItem(
            icon: Icons.task_alt,
            title: 'Tasks',
          ),
          BarItem(
            icon: Icons.pie_chart,
            title: 'Analytics',
          ),*/
          BarItem(
            icon: Icons.settings,
            title: 'Settings',
          ),

          /// Add more BarItem if you want
        ],
      ),
    );
  }
}
