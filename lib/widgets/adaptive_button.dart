import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final VoidCallback handler;

  AdaptiveButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    bool isIos = UniversalPlatform.isIOS;
    bool isWeb = UniversalPlatform.isWeb;
    return (isIos || isWeb)
        ? CupertinoButton(
            onPressed: handler,
            child: const Text(
              'Choose Date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 224, 222, 222),
              ),
            ),
          )
        : TextButton(
            onPressed: handler,
            child: const Text(
              "Choose Date",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}
