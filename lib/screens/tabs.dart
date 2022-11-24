import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grab_grub_app/models/userModel.dart';
import 'package:grab_grub_app/screens/Message/conversation.dart';
import 'package:grab_grub_app/screens/Profile/profile.dart';

import 'home.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with TickerProviderStateMixin {
  late TabController controller;

  void initState() {
    super.initState();
    controller = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
          labelColor: Colors.grey[700],
          unselectedLabelColor: Colors.grey[400],
          indicatorColor: Colors.white,
          controller: controller,
          tabs: [
            Tab(
                icon: Icon(
              Icons.home,
            )),
            Tab(
              icon: Icon(Icons.message),
            ),
            Tab(icon: Icon(Icons.person)),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          Home(),
          Conversation(),
          Profile(user: UserModel.fromHive(), controller: controller),
        ],
      ),
    );
  }
}
