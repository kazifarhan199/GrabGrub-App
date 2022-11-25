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
  String message = '';

  void postlistMethod() async {
    setState(() => loading = true);
    try {
      postlist = await PostModel.postList();
      setState(() => message = '');
    } catch (e) {
      setState(() => message = e.toString());
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

  Future<void> refreshMethod() async {
    postlistMethod();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: Text("GrabGrub"),
              centerTitle: true,
            ),
            body: RefreshIndicator(
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
