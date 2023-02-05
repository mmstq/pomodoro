import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: theme.appBarTheme.titleTextStyle!.color,
        ),
        title: const Text('About'),
        backgroundColor: theme.colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(

        ),
      ),
    );
  }
}
