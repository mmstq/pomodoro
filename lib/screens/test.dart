import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:workmanager/workmanager.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextButton(onPressed: (){
            Workmanager().registerOneOffTask('uniqueName', 'taskName',initialDelay: Duration(seconds: 30));
          }, child: Text("start"))
        ],
      ),
    );
  }
}
