import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grab_grub_app/models/postModel.dart';
import 'package:grab_grub_app/screens/postCreate.dart';
import 'package:grab_grub_app/screens/utils/error_widget.dart';
import 'package:grab_grub_app/screens/utils/page_loading.dart';

import 'post.dart';
import 'postCreate.dart';

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
          title: Text("GrabGrub"),
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
                            message: "No Posts to show",
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PostCreate())),
        ));
  }
}
