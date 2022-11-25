import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grab_grub_app/models/postModel.dart';
import 'package:grab_grub_app/models/userModel.dart';
import 'package:grab_grub_app/screens/utils/error_widget.dart';
import 'package:grab_grub_app/screens/utils/page_loading.dart';

import '../post.dart';

class LikedPosts extends StatefulWidget {
  UserModel user;
  LikedPosts({required this.user, super.key});

  @override
  State<LikedPosts> createState() => _LikedPostsState();
}

class _LikedPostsState extends State<LikedPosts> {
  List<PostModel> postlist = [];
  bool loading = true;
  String message = '';

  void postlistMethod() async {
    setState(() => loading = true);
    try {
      postlist =
          await PostModel.postList(username: widget.user.username, liked: true);
      setState(() => message = '');
    } catch (e) {
      setState(() => message = e.toString());
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    postlistMethod();
    super.initState();
  }

  Future<void> refreshMethod() async {
    setState(() => loading = true);
    await Future.delayed(Duration(seconds: 1));
    postlistMethod();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liked Posts"),
        centerTitle: true,
      ),
      body: loading
          ? PageLoading()
          : RefreshIndicator(
              onRefresh: refreshMethod,
              child: message != ''
                  ? Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info,
                              size: 50,
                            ),
                            Text(message),
                            TextButton(
                                onPressed: refreshMethod,
                                child: Text("Refresh"))
                          ],
                        ),
                      ),
                    )
                  : postlist.length == 0
                      ? errorWidget(
                          message: "No liked posts",
                          refreshMethod: refreshMethod,
                        )
                      : ListView.builder(
                          itemCount: postlist.length,
                          itemBuilder: (BuildContext context, int index) {
                            return PostCard(
                              post: postlist[index],
                            );
                          }),
            ),
    );
  }
}
