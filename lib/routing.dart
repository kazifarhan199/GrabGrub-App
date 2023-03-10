import 'package:flutter/material.dart';
import 'package:grab_grub_app/models/postModel.dart';
import 'package:grab_grub_app/models/userModel.dart';
import 'package:grab_grub_app/screens/Message/message.dart';
import 'package:grab_grub_app/screens/Profile/leked_posts.dart';
import 'package:grab_grub_app/screens/login.dart';
import 'package:grab_grub_app/screens/navigationBar.dart';
import 'package:grab_grub_app/screens/postdetail.dart';
import 'package:grab_grub_app/screens/tabs.dart';
import 'package:grab_grub_app/screens/wrapper.dart';

import 'screens/home.dart';
import 'screens/register.dart';

class Routing {
  static wrapperPage(var context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Wrapper()));
  }

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
        .pushReplacement(MaterialPageRoute(builder: (context) => Tabs()));
  }

  static messagePage({var context, required UserModel user}) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Message(user: user)));
  }

  static postDetailPage({required var context, required PostModel post}) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PostDetail(post: post)));
  }

  static postLikedPage({required var context, required UserModel user}) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LikedPosts(user: user)));
  }
}
