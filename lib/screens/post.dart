import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grab_grub_app/models/claimModel.dart';
import 'package:grab_grub_app/models/messageModel.dart';
import 'package:grab_grub_app/models/postModel.dart';
import 'package:grab_grub_app/models/userModel.dart';
import 'package:grab_grub_app/screens/utils/page_loading.dart';

import '../routing.dart';
import 'Profile/profile.dart';
import 'home.dart';

class PostCard extends StatefulWidget {
  bool goToUser;
  PostModel post;
  bool showDetails;
  PostCard(
      {required this.post,
      this.goToUser = true,
      this.showDetails = false,
      super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool imageLoading = false;
  bool userLoading = false, messageLoading = false, likingLoading = false;
  String quantity = "";
  userProfileMethod() async {
    if (widget.goToUser) {
      setState(() => userLoading = true);
      try {
        UserModel user = await UserModel.getProfile(userId: widget.post.userid);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Profile(
                      user: user,
                    )));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
    setState(() => userLoading = false);
  }

  messageMethod() async {
    bool messageLoading = false;

    setState(() => messageLoading = true);
    try {
      UserModel user = await UserModel.getProfile(userId: widget.post.userid);
      MessageModel _message = await MessageModel.sendMessage(
          text: "", toUserId: user.id, post: widget.post.id);

      Routing.messagePage(context: context, user: user);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => messageLoading = false);
  }

  addLikeMethod(PostModel post) async {
    setState(() => likingLoading = true);
    try {
      bool done = await post.addLike();
      setState(() {
        widget.post.liked = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => likingLoading = false);
  }

  removeLikeMethod(PostModel post) async {
    setState(() => likingLoading = true);
    try {
      bool done = await post.removeLike();
      setState(() {
        widget.post.liked = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => likingLoading = false);
  }

  manageLikeMethod(PostModel post) {
    if (post.liked) {
      removeLikeMethod(post);
    } else {
      addLikeMethod(post);
    }
  }

  claimMethod() async {
    setState(() => imageLoading = true);
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      if (quantity == "") {
        throw "Please describe how many servings you want to claim";
      }
      int quantity_int = int.parse(quantity);
      await ClaimModel.sendClaim(post: widget.post, quantity: quantity_int);
      Routing.postDetailPage(context: context, post: widget.post);
      setState(() {
        imageLoading = false;
        widget.post.servings = widget.post.servings - 1;
      });
    } catch (e) {
      setState(() {
        imageLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        if (widget.showDetails == false)
          Routing.postDetailPage(context: context, post: widget.post)
      },
      child: Card(
        elevation: 0.4,
        child: Column(
          children: [
            ListTile(
              title: InkWell(
                onTap: userProfileMethod,
                child: Row(children: [
                  userLoading
                      ? CircularProgressIndicator()
                      : CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(widget.post.userImage)),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(widget.post.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ),
                          ],
                        ),
                        Text(widget.post.date,
                            style: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 10)),
                      ]),
                ]),
              ),
              trailing: Icon(Icons.keyboard_control),
            ),
            imageLoading
                ? SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: PageLoading())
                : InkWell(
                    onTap: () {
                      showImageViewer(
                          context,
                          NetworkImage(
                            widget.post.pic,
                          ),
                          backgroundColor: Color.fromARGB(248, 239, 239, 239),
                          closeButtonColor: Colors.grey,
                          swipeDismissible: true);
                    },
                    child: Image.network(
                      widget.post.pic,
                      height: 300,
                    ),
                  ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                likingLoading
                    ? IconButton(
                        icon: CircularProgressIndicator(),
                        onPressed: () {},
                      )
                    : IconButton(
                        onPressed: () => manageLikeMethod(widget.post),
                        icon: widget.post.liked
                            ? Icon(
                                Icons.favorite,
                                color: Colors.pink,
                                size: 30.0,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Colors.pink,
                                size: 30.0,
                              ),
                      ),
                SizedBox(
                  width: 5,
                ),
                // Text(widget.post.likes.toString()),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: PopupMenuButton(
                      position: PopupMenuPosition.under,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Center(
                            child: Text(
                          'Claim',
                          style: TextStyle(color: Colors.white),
                        )),
                        decoration: BoxDecoration(
                          // shape: BoxShape.rectangle,
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7.0),
                            topRight: Radius.circular(7.0),
                            bottomLeft: Radius.circular(7.0),
                            bottomRight: Radius.circular(7.0),
                          ),
                        ),
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
                                  width: 200,
                                  child: TextFormField(
                                    onChanged: (val) {
                                      quantity = val;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "# out of " +
                                          widget.post.servings.toString() +
                                          " servings",
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: claimMethod,
                                    icon: Icon(Icons.check))
                              ],
                            ),
                          )
                        ];
                      }),
                ),

                SizedBox(
                  width: 20,
                ),
                messageLoading
                    ? CircularProgressIndicator()
                    : IconButton(
                        icon:
                            Icon(Icons.message, color: Colors.grey, size: 30.0),
                        onPressed: messageMethod,
                      ),
                SizedBox(
                  width: 5,
                ),
                // Text(widget.items[widget.index].comments.toString()),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.post.title,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Tooltip(
                    message: "Number of servings",
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.grey[200],
                      child: Text(
                        widget.post.servings.toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            !widget.showDetails
                ? Container()
                : Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.post.text,
                          //style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
