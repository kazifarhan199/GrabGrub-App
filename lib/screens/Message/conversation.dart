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
    try {
      users = await ConversationModel.getConversations();
      setState(() {
        loading = false;
        message = '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          duration: Duration(days: 365),
          action: SnackBarAction(label: "Retry", onPressed: refreshMethod)));
      setState(() {
        loading = false;
        message = e.toString();
      });
    }
  }

  messageMethod(int user_id, String username) {
    Routing.messagePage(context: context, user_id: user_id, username: username);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? PageLoading()
        : Scaffold(
            appBar: AppBar(title: Text("Messages")),
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
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => messageMethod(
                              users[index].id, users[index].username),
                          child: Card(
                            elevation: 7.0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[400],
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    users[index].username,
                                    style: TextStyle(fontSize: 20.0),
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
