import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grab_grub_app/screens/post.dart';

import '../models/postModel.dart';

class PostDetail extends StatefulWidget {
  PostModel post;
  PostDetail({required this.post, super.key});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        print(details.delta.distance);
        if (details.delta.distance < 0.8) {
          Navigator.of(context).pop();
        }
        // print(details.delta.direction);
      },
      child: Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PostCard(
                    post: widget.post,
                    showDetails: true,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
