import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grab_grub_app/models/claimModel.dart';
import 'package:grab_grub_app/models/postModel.dart';
import 'package:grab_grub_app/models/userModel.dart';
import 'package:grab_grub_app/screens/utils/error_widget.dart';
import 'package:grab_grub_app/screens/utils/page_loading.dart';

import '../../models/utils.dart/conversationModel.dart';
import '../../routing.dart';

class ClaimHistory extends StatefulWidget {
  const ClaimHistory({super.key});

  @override
  State<ClaimHistory> createState() => _ClaimHistoryState();
}

class _ClaimHistoryState extends State<ClaimHistory> {
  List<ClaimModel> claims = [];
  bool loading = true;
  String message = '';

  @override
  void initState() {
    getClaimsMethod();
    super.initState();
  }

  Future<void> refreshMethod() async {
    setState(() => loading = true);
    await Future.delayed(Duration(seconds: 1));
    await getClaimsMethod();
    setState(() => loading = false);
  }

  getClaimsMethod() async {
    setState(() => loading = true);
    try {
      claims = await ClaimModel.getClaims();
      setState(() {
        loading = false;
        message = '';
      });
    } catch (e) {
      setState(() {
        loading = false;
        message = e.toString();
      });
    }
  }

  postMethod(int id) async {
    setState(() {
      loading = true;
    });
    PostModel post = await PostModel.postDetail(id: id);
    Routing.postDetailPage(context: context, post: post);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Claimed History"),
        centerTitle: true,
      ),
      body: loading
          ? PageLoading()
          : RefreshIndicator(
              onRefresh: refreshMethod,
              child: message != ''
                  ? errorWidget(
                      message: message,
                      refreshMethod: refreshMethod,
                    )
                  : claims.length == 0
                      ? errorWidget(
                          message: "No Claims",
                          refreshMethod: refreshMethod,
                        )
                      : ListView.builder(
                          itemCount: claims.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => postMethod(claims[index].post),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: CachedNetworkImage(
                                            imageUrl: claims[index].image),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Expanded(
                                        child: Text(
                                          claims[index].text,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                      ),
                                      Tooltip(
                                        message: "Number of servings claimed",
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor: Colors.grey[200],
                                          child: Text(
                                            claims[index].quantity.toString(),
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ),
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
