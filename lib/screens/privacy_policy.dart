import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: theme.appBarTheme.titleTextStyle!.color,
        ),
        title: const Text('Privacy Policy'),
        backgroundColor: theme.colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "This Privacy Policy is about an Android application provided free, known as Focus Timer on the Google Play Store."
                  " This application does not collect, transmit, or store any user's personal information.\n\nHowever we collect some information about your device when the application crashes."
                  " This data is very important for us as this helps us to improve and fix bugs in this application so that we can provide better user experience.",
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'The type of information we collect are following:',
                    style: theme.textTheme.titleLarge!.copyWith(
                        fontSize: 20, color: theme.textTheme.titleSmall!.color),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Text(
                    '1. Number of users and sessions'
                    '\n2. Session duration'
                    '\n3. Operating systems'
                    '\n4. Device models'
                    '\n5. Geography'
                    '\n6. First launches'
                    '\n7. App opens'
                    '\n8. App updates'
                    '\n9. In-app purchases',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  'Contact us',
                  style: theme.textTheme.titleLarge!.copyWith(
                      fontSize: 28, color: theme.textTheme.titleSmall!.color),
                ),
                const SizedBox(
                  height: 16,
                ),
                RichText(
                    text:
                        TextSpan(style: theme.textTheme.titleSmall, children: [
                  const TextSpan(
                      text:
                          "If you have any questions or suggestions about my Privacy Policy or the app, "
                          "do not hesitate to contact me \n"),
                  TextSpan(
                      text: 'mohdmushtak59@gmail.com',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('he');
                        })
                ]))
              ],
            ) /*RichText(
            textDirection: TextDirection.,
            text: TextSpan(style: theme.textTheme.titleSmall, children: const [
              TextSpan(text: ),
              TextSpan(
;                text:
                      )
            ]),
          ),*/
            ),
      ),
    );
  }
}
