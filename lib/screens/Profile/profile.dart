import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grab_grub_app/models/userModel.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  UserModel user;
  Profile({required this.user, super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool loading = false;
  XFile? image;
  bool needSaving = false;
  final ImagePicker picker = ImagePicker();
  String username = "", bio = "";
  var box = Hive.box('userBox');

  Future<void> getImage(int value) async {
    if (widget.user.id == box.get('id')) {
      XFile? _image;
      final LostDataResponse response = await picker.retrieveLostData();
      if (value == 0) {
        _image = await picker.pickImage(source: ImageSource.camera);
      } else {
        _image = await picker.pickImage(source: ImageSource.gallery);
      }
      if (_image != null) {
        setState(() {
          image = _image;
          needSaving = true;
        });
      }
    } else {
      // If some other users profile
    }
  }

  editUsernameMethod(String val) {
    if (widget.user.id == box.get('id')) {
      setState(() {
        username = val;
        needSaving = true;
      });
    } else {
      // If some other users profile

    }
  }

  editBioMethod(String val) {
    if (widget.user.id == box.get('id')) {
      setState(() {
        bio = val;
        needSaving = true;
      });
    } else {
      // If some other users profile

    }
  }

  @override
  void initState() {
    super.initState();
    username = widget.user.username;
    bio = widget.user.bio;
  }

  Future<void> refreshMethod() async {
    setState(() => loading = true);
    try {
      await widget.user.refreshProfile();
      setState(() {
        loading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        loading = false;
      });
    }
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
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: refreshMethod,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: PopupMenuButton(
                        iconSize: 160,
                        position: PopupMenuPosition.under,
                        icon: image == null
                            ? CircleAvatar(
                                radius: 80,
                                backgroundImage: CachedNetworkImageProvider(
                                    widget.user.image),
                              )
                            : CircleAvatar(
                                radius: 80,
                                backgroundImage: FileImage(File(image!.path)),
                              ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem<int>(
                              value: 0,
                              child: Row(
                                children: [
                                  Icon(Icons.camera_alt_outlined),
                                  Text(" Camery")
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.photo_library_outlined),
                                  Text(" Gallery")
                                ],
                              ),
                            ),
                          ];
                        },
                        onSelected: (value) => getImage(value)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: PopupMenuButton(
                        position: PopupMenuPosition.under,
                        child: Text(
                          username,
                          style: TextStyle(fontSize: 25.0),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem<int>(
                              value: 0,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 240,
                                    child: TextFormField(
                                      onChanged: editUsernameMethod,
                                      initialValue: username,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Username',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ];
                        },
                        onSelected: (value) => getImage(value)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                    child: PopupMenuButton(
                        position: PopupMenuPosition.under,
                        child: Text(bio),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem<int>(
                              value: 0,
                              // height: 120,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    child: TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      onChanged: editBioMethod,
                                      initialValue: bio,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'bio',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ];
                        },
                        onSelected: (value) => getImage(value)),
                  )),
                ],
              ),
            ),
      floatingActionButton: !needSaving
          ? Container()
          : FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.save),
            ),
    );
  }
}
