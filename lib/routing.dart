import 'package:flutter/material.dart';
import 'package:grab_grub_app/models/userModel.dart';
import 'package:grab_grub_app/screens/Message/message.dart';
import 'package:grab_grub_app/screens/login.dart';
import 'package:grab_grub_app/screens/navigationBar.dart';

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
        .pushReplacement(MaterialPageRoute(builder: (context) => navigation()));
  }

  static messagePage(
      {var context, required int user_id, required UserModel user}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Message(user_id: user_id, user: user)));
  }
}
