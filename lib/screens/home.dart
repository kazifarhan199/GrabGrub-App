import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grab_grub_app/models/postModel.dart';

import 'post.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<PostModel> postlist = [];
  bool loading = true;

  void postlistMethod() async {
    setState(() => loading = true);
    try {
      postlist = await PostModel.postList();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    postlistMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator()
        : Container(
            child: ListView.builder(
                itemCount: postlist.length,
                itemBuilder: (BuildContext context, int index) {
                  return PostCard(
                    items: postlist,
                    index: index,
                  );
                }),
          );
  }
}
