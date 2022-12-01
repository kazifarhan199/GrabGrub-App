import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grab_grub_app/routing.dart';
import 'package:grab_grub_app/screens/post.dart';
import 'package:image_picker/image_picker.dart';

import '../models/postModel.dart';

class PostCreate extends StatefulWidget {
  PostCreate({super.key});

  @override
  State<PostCreate> createState() => _PostCreateState();
}

class _PostCreateState extends State<PostCreate> {
  bool imageNotUplaoded = true;

  var _numberForm = GlobalKey<FormState>();
  RegExp _digitRegex = RegExp("[0-9]+");
  bool isValidForm = false;
  final ImagePicker picker = ImagePicker();
  XFile? image;
  String title = "";
  int servings = 0;
  TextEditingController descriptionController = TextEditingController();

  Future<void> getImage(int value) async {
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
      });
    }
  }

  saveMethod() async {
    try {
      await PostModel.CreatePost(
          title: title,
          description: descriptionController.text,
          servings: servings,
          image: image);
      Routing.homePage(context);
    } catch (e) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'New Post',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
              ),
              Center(
                child: PopupMenuButton(
                    iconSize: MediaQuery.of(context).size.width - 20,
                    position: PopupMenuPosition.under,
                    icon: image == null
                        ? Image.asset('assets/image_placeholder.png')
                        : Image.file((File(image!.path))),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: [
                              Icon(Icons.camera_alt_outlined),
                              Text(" Camera")
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
                width: 25,
              ),
              SizedBox(
                width: 5,
              ),
              // SizedBox(
              //   child: Text("Title"),
              //   width: (MediaQuery.of(context).size.width / 10) * 3.5,
              // ),
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: SizedBox(
                    child: TextField(
                      onChanged: (val) => title = val,
                      decoration: InputDecoration(
                          hintText: "Enter title", border: InputBorder.none),
                    ),
                    width: MediaQuery.of(context).size.width - 20,
                  ),
                ),
              ),

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: SizedBox(
                    child: TextField(
                      onChanged: (val) => servings = int.parse(val),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Number of Servings",
                          border: InputBorder.none),
                    ),
                    width: MediaQuery.of(context).size.width - 20,
                  ),
                ),
              ),

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: SizedBox(
                    child: TextField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                          hintText: "Description", border: InputBorder.none),
                    ),
                    width: MediaQuery.of(context).size.width - 20,
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: saveMethod,
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
    );
  }
}
