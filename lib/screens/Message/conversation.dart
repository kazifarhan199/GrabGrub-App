import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grab_grub_app/models/userModel.dart';

import '../../models/utils.dart/conversationModel.dart';
import '../../routing.dart';
import '../utils/page_loading.dart';

class Conversation extends StatefulWidget {
  const Conversation({super.key});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  List<UserModel> users = [];
  bool loading = true;
  String message = '';

  @override
  void initState() {
    getConversationsMethod();
    super.initState();
  }

  Future<void> refreshMethod() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    await getConversationsMethod();
  }

  getConversationsMethod() async {
    setState(() => loading = true);
    // try {
    users = await ConversationModel.getConversations();
    setState(() {
      loading = false;
      message = '';
    });
    // } catch (e) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text(e.toString())));
    //   setState(() {
    //     loading = false;
    //     message = e.toString();
    //   });
    // }
  }

  messageMethod(int user_id, UserModel user) {
    Routing.messagePage(context: context, user: user);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? PageLoading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Messages"),
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
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () =>
                              messageMethod(users[index].id, users[index]),
                          child: Card(
                            elevation: 7.0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        users[index].image),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Flexible(
                                    child: Text(
                                      users[index].username,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          );
  }
}
