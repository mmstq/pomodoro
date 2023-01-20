import 'package:flutter/material.dart';
import 'package:pomodoro/screens/analytics.dart';
import 'package:pomodoro/screens/settings.dart';
import 'package:pomodoro/screens/task_page.dart';
import 'package:pomodoro/screens/timer.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController pageController = PageController();
  int index = 0;
  final List<String> title = ['Focus', 'Tasks', 'Analytics', 'Settings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      child: Text('Contact'),
                    ),
                    const PopupMenuItem<String>(
                      child: Text('Contact'),
                    ),
                  ])
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          title[index],
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [
          Timer(),
          TaskPage(),
          Analytics(),
          Setting(),
        ],
      ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Theme.of(context).primaryColor,
        onButtonPressed: (i) {
          setState(() {
            index = i;
          });
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuad);
        },
        iconSize: 25,
        inactiveColor: Colors.white38,
        activeColor: Colors.white,
        selectedIndex: index,
        barItems: [
          BarItem(
            icon: Icons.timelapse_rounded,
            title: 'Timer',
          ),
          BarItem(
            icon: Icons.task_alt,
            title: 'Tasks',
          ),
          BarItem(
            icon: Icons.pie_chart,
            title: 'Analytics',
          ),
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
