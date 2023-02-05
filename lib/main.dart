import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pomodoro/utils/data.dart';
import 'package:pomodoro/homepage.dart';
import 'package:pomodoro/providers/theme_mode_notifier.dart';
import 'package:pomodoro/providers/timer_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  await initialization();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ChangeNotifierProvider(create: (_) => TimerProvider())
    ],
    child: const MyApp(),
  ));
}

Future<void> initialization() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SharedPrefs.init();
  /*AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            onlyAlertOnce: true,
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true
  );*/
}

//maven baloo2 rajdhani sairaSemiCondensed itim coda

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: getTheme(context),
      darkTheme: getDarkTheme(context),
      debugShowCheckedModeBanner: false,
      theme: getLightTheme(context),
      home: const HomePage(),
    );
  }

  ThemeMode getTheme(BuildContext context) {
    var mode = Provider.of<ThemeNotifier>(context).themeMode;
    switch (mode) {
      case 0:
        return ThemeMode.light;
      case 1:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  ThemeData getLightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.grey.shade100,
      colorScheme: const ColorScheme.light(
          primaryContainer: Colors.white, tertiary: Colors.black87),
      popupMenuTheme: const PopupMenuThemeData(
        // color: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.black26)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          unselectedItemColor: Colors.black26,
          selectedItemColor: Colors.indigo),
      fontFamily: "Sofia",
      sliderTheme: SliderThemeData(
          activeTickMarkColor: Colors.white,
          activeTrackColor: Colors.indigo,
          inactiveTrackColor: Colors.indigo.withOpacity(0.3),
          inactiveTickMarkColor: Colors.white38),
      textTheme: const TextTheme(
          titleSmall: TextStyle(
              //title in sub setting
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w400),
          displaySmall: TextStyle(
              fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w300),
          titleMedium: TextStyle(
              fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w300),
          titleLarge: TextStyle(
              color: Colors.black38,
              fontSize: 40,
              fontWeight: FontWeight.w900)),
      appBarTheme: AppBarTheme.of(context).copyWith(
          titleTextStyle: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: 'Sofia'),
          iconTheme: const IconThemeData(color: Colors.black)),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) =>
            states.contains(MaterialState.selected)
                ? Colors.white
                : Colors.black),
        trackColor: MaterialStateProperty.resolveWith((states) =>
            states.contains(MaterialState.selected)
                ? Colors.indigo
                : Colors.grey.withOpacity(0.4)),
        thumbIcon: MaterialStateProperty.resolveWith((states) =>
            states.contains(MaterialState.selected)
                ? const Icon(Icons.check, color: Colors.indigo)
                : const Icon(Icons.close)),
      ),
      primarySwatch: Colors.indigo,
    );
  }

  ThemeData getDarkTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF1C1F23),
      popupMenuTheme: const PopupMenuThemeData(
        color: Color(0xFF1C1F23),
        surfaceTintColor: Color(0xFF1C1F23),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.black26)),
      ),
      sliderTheme: SliderThemeData(
          activeTickMarkColor: Colors.white,
          activeTrackColor: Colors.indigo,
          inactiveTrackColor: Colors.indigo.withOpacity(0.3),
          inactiveTickMarkColor: Colors.white38),
      colorScheme: const ColorScheme.light(
        primaryContainer: Color(0xFF16181A),
        tertiary: Colors.grey,
        brightness: Brightness.dark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))),
      fontFamily: "Sofia",
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          unselectedItemColor: Colors.white38, selectedItemColor: Colors.white),
      textTheme: const TextTheme(
          titleSmall: TextStyle(
              //title in sub setting
              fontSize: 18,
              color: Colors.white70,
              fontWeight: FontWeight.w400),
          displaySmall: TextStyle(
              // note text in sub setting
              fontSize: 15,
              color: Colors.white60,
              fontWeight: FontWeight.w300),
          titleMedium: TextStyle(
              // title in settings
              fontSize: 20,
              color: Colors.white70,
              fontWeight: FontWeight.w300),
          titleLarge: TextStyle(
              color: Colors.white70,
              fontSize: 40,
              fontWeight: FontWeight.w900)),
      appBarTheme: AppBarTheme.of(context).copyWith(
          titleTextStyle: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'Sofia'),
          iconTheme: const IconThemeData(color: Colors.white)),
      radioTheme:
          RadioThemeData(fillColor: MaterialStateProperty.all(Colors.white70)),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) =>
            states.contains(MaterialState.selected)
                ? Colors.white
                : Colors.black),
        trackColor: MaterialStateProperty.resolveWith((states) =>
            states.contains(MaterialState.selected)
                ? Colors.indigo
                : Colors.indigo.withOpacity(0.4)),
        thumbIcon: MaterialStateProperty.resolveWith((states) =>
            states.contains(MaterialState.selected)
                ? const Icon(Icons.check, color: Colors.indigo)
                : const Icon(Icons.close)),
      ),
      primarySwatch: Colors.indigo,
      brightness: Brightness.dark,
    );
  }
}
