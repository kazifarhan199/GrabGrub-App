import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grab_grub_app/models/userModel.dart';
import 'package:grab_grub_app/screens/utils/error_widget.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/postModel.dart';
import '../../routing.dart';
import '../post.dart';
import '../utils/page_loading.dart';

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
  bool postLoading = true, savingLoading = false;
  String message = '', email = '', errormessage = "";
  bool canedit = false;

  void postlistMethod() async {
    if (mounted) setState(() => postLoading = true);
    try {
      List<PostModel> postlist_ =
          await PostModel.postList(username: widget.user.username);
      setState(() {
        postlist = postlist_;
      });
      setState(() => errormessage = '');
    } catch (e) {
      if (mounted) setState(() => errormessage = e.toString());
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

  editemailMethod(String val) {
    if (widget.user.id == box.get('id')) {
      setState(() {
        email = val;
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

  saveMthod() async {
    if (mounted) setState(() => savingLoading = true);
    try {
      UserModel _user = await widget.user
          .editUser(username: username, email: email, bio: bio, image: image);
      setState(() {
        needSaving = false;
        widget.user = _user;
      });
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    if (mounted) setState(() => savingLoading = false);
  }

  revertMethod() {
    setState(() {
      bio = widget.user.bio;
      username = widget.user.username;
      image = null;
      needSaving = false;
      email = widget.user.email;
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

  listnerMethod() {
    if (widget.controller!.indexIsChanging) {
      if (widget.controller!.index == 2) {
      } else if (needSaving) {
        widget.controller!.index = 2;
        showAlertDialog(context,
            title: "Unsaved Changes",
            content: "Please save your unsaved changes.");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.addListener(listnerMethod);
    }
    canedit = widget.user.username == box.get('username');

    postlistMethod();
    username = widget.user.username;
    bio = widget.user.bio;
    email = widget.user.email;
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller!.removeListener(listnerMethod);
    }
    super.dispose();
  }

  messageMethod() {
    Routing.messagePage(context: context, user: widget.user);
  }

  Future<void> refreshMethod() async {
    setState(() => loading = true);
    await Future.delayed(Duration(seconds: 1));
    try {
      await widget.user.refreshProfile();
      setState(() {
        loading = false;
      });
    } catch (e) {
      if (errormessage == "") {
        errormessage = e.toString();
      }
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
        actions: [
          widget.user.id != box.get("id")
              ? Container()
              : IconButton(
                  onPressed: () {
                    widget.user.logout();
                    Routing.wrapperPage(context);
                  },
                  icon: Icon(Icons.logout))
        ],
      ),
      body: loading
          ? PageLoading()
          : RefreshIndicator(
              onRefresh: refreshMethod,
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: postlist.length + 2,
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
                                            Text(" Camera")
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
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              widget.user.id == box.get('id')
                                  ? IconButton(
                                      onPressed: () => Routing.postLikedPage(
                                          context: context, user: widget.user),
                                      icon: Icon(
                                        Icons.favorite,
                                        color: Colors.pink,
                                      ))
                                  : IconButton(
                                      onPressed: () {}, icon: Container()),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Center(
                                    child: PopupMenuButton(
                                        position: PopupMenuPosition.under,
                                        child: Text(
                                          username,
                                          style: TextStyle(fontSize: 25.0),
                                        ),
                                        constraints: BoxConstraints(
                                          maxWidth:
                                              MediaQuery.of(context).size.width,
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
                                                        onChanged:
                                                            editUsernameMethod,
                                                        initialValue: username,
                                                        decoration:
                                                            InputDecoration(
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
                              ),
                              IconButton(
                                  onPressed: messageMethod,
                                  icon: Icon(Icons.message)),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Center(
                              child: PopupMenuButton(
                                  position: PopupMenuPosition.under,
                                  child: Text(
                                    email,
                                    style: TextStyle(fontSize: 10.0),
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
                                                  onChanged: editemailMethod,
                                                  initialValue: email,
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    hintText: 'email',
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
                    else if (errormessage == "" &&
                        postlist.length > 0 &&
                        index <= postlist.length)
                      return postLoading
                          ? Container()
                          : PostCard(
                              post: postlist[index - 1], goToUser: false);
                    else if (errormessage != "")
                      return Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          errorWidget(
                            message: errormessage,
                            refreshMethod: refreshMethod,
                          ),
                        ],
                      );
                    else if (postlist.length == 0)
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 100,
                                ),
                                Text("No posts yet"),
                                TextButton(
                                    onPressed: refreshMethod,
                                    child: Text("Refresh"))
                              ],
                            ),
                          ),
                        ),
                      );
                    else
                      return Container();
                  }),
            ),
      floatingActionButton: !needSaving
          ? Container()
          : FloatingActionButton(
              onPressed: saveMthod,
              child: savingLoading
                  ? CircularProgressIndicator()
                  : Icon(Icons.save),
            ),
    );
  }
}
