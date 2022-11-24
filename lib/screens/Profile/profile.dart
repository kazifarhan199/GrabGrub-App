import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grab_grub_app/models/userModel.dart';

class Profile extends StatefulWidget {
  UserModel user;
  Profile({required this.user, super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool loading = false;

  Future<void> refreshMethod() async {
    setState(() => loading = true);
    await widget.user.refreshProfile();
    setState(() {
      widget.user = UserModel.fromHive();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user.image);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: loading
          ? CircularProgressIndicator()
          : RefreshIndicator(
              onRefresh: refreshMethod,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: CachedNetworkImageProvider(
                        widget.user.image,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      widget.user.username,
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 14),
                      child: Text(widget.user.bio),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
