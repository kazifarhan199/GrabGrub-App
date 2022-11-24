import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:grab_grub_app/models/messageModel.dart';
import 'package:grab_grub_app/models/userModel.dart';
import 'package:image_picker/image_picker.dart';

class Message extends StatefulWidget {
  int user_id;
  String username;
  Message({required this.user_id, required this.username, super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  UserModel user = UserModel.fromHive();
  List<MessageModel> messages = [];
  bool loading = true, sending = false;
  TextEditingController messageInputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker picker = ImagePicker();
  XFile? image;

  Future<void> getImage(int value) async {
    XFile? _image;
    final LostDataResponse response = await picker.retrieveLostData();
    if (value == 0) {
      _image = await picker.pickImage(source: ImageSource.camera);
    } else {
      _image = await picker.pickImage(source: ImageSource.gallery);
    }
    if (_image != null) {
      setState(() => image = _image);
    }
  }

  Future getMessagesMethod() async {
    setState(() => loading = true);
    messages = (await MessageModel.getMessages(widget.user_id));
    setState(() => loading = false);
  }

  sendMessageMethod() async {
    setState(() => sending = true);
    MessageModel _message = messages[0];
    try {
      _message = await MessageModel.sendMessage(
          text: messageInputController.text,
          toUserId: widget.user_id,
          image: image);
      setState(() {
        sending = false;
        messageInputController.text = '';
        image = null;
      });
      messages.insert(0, _message);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      setState(() {
        sending = false;
      });
    }
  }

  Future<void> refreshMethod() async {}

  @override
  void initState() {
    getMessagesMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[400],
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.username),
          ],
        ),
        centerTitle: true,
      ),
      body: loading
          ? Container()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          messages[index].image == ""
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: user.username ==
                                            messages[index].senderUsername
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showImageViewer(
                                              context,
                                              NetworkImage(
                                                messages[index].image,
                                              ),
                                              swipeDismissible: true);
                                        },
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 100,
                                              child: CachedNetworkImage(
                                                imageUrl: messages[index].image,
                                                height: 100,
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                                // loadingBuilder: (context, i, j) {
                                                //   return CircularProgressIndicator();
                                                // },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          messages[index].text == ""
                              ? Container()
                              : Row(
                                  mainAxisAlignment: user.username ==
                                          messages[index].senderUsername
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                40),
                                        child: Card(
                                          elevation: 7.0,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 6),
                                            child: Column(
                                              children: [
                                                Text(
                                                  messages[index].text,
                                                  style:
                                                      TextStyle(fontSize: 17),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  // onPressed: () {},
                  children: [
                    SizedBox(
                      width: 20,
                      height: 60,
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        image == null
                            ? Container()
                            : Row(
                                children: [
                                  Stack(
                                    children: [
                                      Image.file(
                                        File(image!.path),
                                        height: 100,
                                      ),
                                      Positioned(
                                        right: -9,
                                        top: -9,
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.cancel,
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              size: 18,
                                            ),
                                            onPressed: () =>
                                                setState(() => image = null)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                        TextFormField(
                            controller: messageInputController,
                            decoration: const InputDecoration(
                              hintText: 'Message',
                            )),
                      ],
                    )),
                    PopupMenuButton(
                        position: PopupMenuPosition.over,
                        icon: Icon(Icons.attach_file),
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
                    IconButton(
                        onPressed: sendMessageMethod,
                        icon: sending
                            ? CircularProgressIndicator()
                            : Icon(
                                Icons.send,
                              )),
                  ],
                ),
              ],
            ),
    );
  }
}
