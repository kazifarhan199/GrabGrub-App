import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'home.dart';
import 'login.dart';
import 'utils/page_loading.dart';
import 'navigationBar.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  var box;
  bool loding = true;

  init() async {
    box = await Hive.openBox('userBox');
    setState(() {
      loding = false;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loding == true) {
      return PageLoading();
    } else {
      return (box.get('id') == null || box.get('id') == 0)
          ? Login()
          : navigation();
    }
  }
}
