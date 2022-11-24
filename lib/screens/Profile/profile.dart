import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grab_grub_app/models/userModel.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/postModel.dart';
import '../post.dart';

class Profile extends StatefulWidget {
  UserModel user;
  TabController? controller;
  Profile({required this.user, this.controller = null, super.key});

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
  List<PostModel> postlist = [];
  bool postLoading = true;
  String message = '';
  bool canedit = false;

  void postlistMethod() async {
    if (mounted) setState(() => postLoading = true);
    try {
      postlist = await PostModel.postList(username: widget.user.username);
      setState(() => message = '');
    } catch (e) {
      if (mounted) setState(() => message = e.toString());
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    if (mounted) setState(() => postLoading = false);
  }

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

  saveMthod() {
    setState(() {
      needSaving = false;
    });
  }

  revertMethod() {
    showAlertDialog(context,
        title: "Unsaved Changes", content: "Please save your unsaved changes.");
    setState(() {
      bio = widget.user.bio;
      username = widget.user.username;
      image = null;
      needSaving = false;
    });
  }

  showAlertDialog(BuildContext context,
      {required String title, required String content}) {
    // set up the button
    Widget saveButton = TextButton(
      child: Text("Save"),
      onPressed: () {
        Navigator.of(context).pop();
        saveMthod();
      },
    );

    Widget resetButton = TextButton(
        child: Text("Reset"),
        onPressed: () {
          Navigator.of(context).pop();
          revertMethod();
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        resetButton,
        saveButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.addListener(() {
        if (widget.controller!.indexIsChanging) {
          if (widget.controller!.index == 2) {
          } else if (needSaving) {
            widget.controller!.index = 2;
            showAlertDialog(context,
                title: "Unsaved Changes",
                content: "Please save your unsaved changes.");
          }
        }
      });
    }
    canedit = widget.user.username == box.get('username');

    postlistMethod();
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
    postlistMethod();
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
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: postlist.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                widget.user.image),
                                      )
                                    : CircleAvatar(
                                        radius: 80,
                                        backgroundImage:
                                            FileImage(File(image!.path)),
                                      ),
                                itemBuilder: (context) {
                                  return [
                                    if (canedit)
                                      PopupMenuItem<int>(
                                        value: 0,
                                        child: Row(
                                          children: [
                                            Icon(Icons.camera_alt_outlined),
                                            Text(" Camery")
                                          ],
                                        ),
                                      ),
                                    if (canedit)
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Center(
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
                                      if (canedit)
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
                                                    border:
                                                        OutlineInputBorder(),
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
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          PopupMenuButton(
                              position: PopupMenuPosition.under,
                              child: Card(
                                  child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 14),
                                  child: Text(bio),
                                ),
                              )),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width,
                              ),
                              itemBuilder: (context) {
                                return [
                                  if (canedit)
                                    PopupMenuItem<int>(
                                      value: 0,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                50,
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.multiline,
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Posts --",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ],
                      );
                    else
                      return postLoading
                          ? Container()
                          : PostCard(
                              items: postlist,
                              index: index - 1,
                              goToUser: false);
                  }
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: SizedBox(
                  //     height: 400,
                  //     child: postLoading
                  //         ? Container()
                  //         : ListView.builder(
                  //             itemBuilder: ((context, index) => PostCard(
                  //                   items: postlist,
                  //                   index: index,
                  //                 )),
                  //             itemCount: 3,
                  //           ),
                  //   ),
                  // )
                  // ],
                  ),
            ),
      floatingActionButton: !needSaving
          ? Container()
          : FloatingActionButton(
              onPressed: saveMthod,
              child: Icon(Icons.save),
            ),
    );
  }
}
