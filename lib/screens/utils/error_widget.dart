import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class errorWidget extends StatelessWidget {
  String message;
  var refreshMethod;
  errorWidget({required this.message, required this.refreshMethod, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info,
              size: 50,
            ),
            Text(message),
            TextButton(onPressed: refreshMethod, child: Text("Refresh"))
          ],
        ),
      ),
    );
  }
}
