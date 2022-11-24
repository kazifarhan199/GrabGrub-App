import 'package:grab_grub_app/models/utils.dart/sendRequest.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

class PostModel {
  String text;
  String pic;
  int likes;
  int comments;
  String name;
  String userImage;

  PostModel({
    required this.text,
    required this.pic,
    required this.likes,
    required this.comments,
    required this.name,
    required this.userImage,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey(['username', 'token'])) {
      return throw ("Can't find user data");
    }
    return PostModel(
      text: json['text'],
      pic: json['image'],
      likes: json['likes'],
      comments: json['comments'],
      name: json['user_username'],
      userImage: json['user_image'],
    );
  }

  static Future<List<PostModel>> postList(
      // required String username,
      // required String token,
      ) async {
    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    String url = '/posts/';
    Map<String, dynamic> data = {};
    int expectedStatusCode = 200;

    // body['text'] = username;
    // body['pic'] = image;
    // body['likes'] = likes;
    // body['comments'] = comments;
    // body['name'] = user_username;

    data = await sendRequest(
      url: url,
      files: files,
      body: body,
      expectedStatusCode: expectedStatusCode,
      needHeader: true,
      Method: "GET",
    );

    //data['username'] = username;
    List<PostModel> posts = [];
    for (var obj in data['results']) {
      posts.add(PostModel.fromJson(obj));
    }

    return posts;
  }
}
