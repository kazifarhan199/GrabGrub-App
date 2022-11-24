import 'package:flutter/material.dart';
import 'package:grab_grub_app/screens/Message/message.dart';
import 'package:grab_grub_app/screens/login.dart';

import 'screens/home.dart';
import 'screens/register.dart';

class Routing {
  static registerPage(var context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Register()));
  }

  static loginPage(var context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }

  static homePage(var context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
  }

  static messagePage(
      {var context, required int user_id, required String username}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Message(user_id: user_id, username: username)));
  }
}
