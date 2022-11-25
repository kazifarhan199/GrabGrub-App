import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grab_grub_app/models/messageModel.dart';
import 'package:grab_grub_app/models/postModel.dart';
import 'package:grab_grub_app/models/userModel.dart';

import '../routing.dart';
import 'Profile/profile.dart';
import 'home.dart';

class PostCard extends StatefulWidget {
  int index;
  bool goToUser;
  List<PostModel> items;
  PostCard(
      {required this.items,
      required this.index,
      this.goToUser = true,
      super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

// mamathaputta
// sagarputtamp
class _PostCardState extends State<PostCard> {
  bool userLoading = false, messageLoading = false;
  userProfileMethod() async {
    if (widget.goToUser) {
      setState(() => userLoading = true);
      try {
        UserModel user = await UserModel.getProfile(
            userId: widget.items[widget.index].userid);
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
      UserModel user =
          await UserModel.getProfile(userId: widget.items[widget.index].userid);
      MessageModel _message = await MessageModel.sendMessage(
          text: "", toUserId: user.id, post: widget.items[widget.index].id);

      Routing.messagePage(context: context, user: user);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => messageLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                        backgroundImage:
                            NetworkImage(widget.items[widget.index].userImage)),
                SizedBox(
                  width: 10,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(widget.items[widget.index].name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ],
                  ),
                  Text(widget.items[widget.index].date,
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 10)),
                ]),
              ]),
            ),
            trailing: Icon(Icons.keyboard_control),
          ),
          InkWell(
            onTap: () {},
            child: Image.network(
              widget.items[widget.index].pic,
              height: 300,
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.favorite,
                color: Colors.pink,
                size: 30.0,
              ),
              SizedBox(
                width: 5,
              ),
              Text(widget.items[widget.index].likes.toString()),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: ElevatedButton(
                  //style: raisedButtonStyle,
                  onPressed: () {},
                  child: Text('Claim'),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              messageLoading
                  ? CircularProgressIndicator()
                  : IconButton(
                      icon: Icon(Icons.message, color: Colors.grey, size: 30.0),
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
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Description: ' + widget.items[widget.index].text,
                    //style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
