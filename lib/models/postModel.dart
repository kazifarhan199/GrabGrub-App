import 'package:grab_grub_app/models/utils.dart/sendRequest.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

class PostModel {
  String title;
  String text;
  String pic;
  int likes;
  int comments;
  String name;
  String userImage;
  int userid;
  int id;
  String date;
  bool liked;

  PostModel({
    required this.title,
    required this.id,
    required this.text,
    required this.pic,
    required this.likes,
    required this.comments,
    required this.name,
    required this.userImage,
    required this.userid,
    required this.date,
    required this.liked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey(['username', 'token'])) {
      return throw ("Can't find user data");
    }
    return PostModel(
      id: json['id'],
      text: json['text'],
      pic: json['image'],
      likes: json['likes'],
      comments: json['comments'],
      name: json['user_username'],
      userImage: json['user_image'],
      userid: json['user'],
      date: json['date'],
      title: json['title'],
      liked: json['has_liked'],
    );
  }

  static Future<List<PostModel>> postList(
      {String username = "", bool liked = false}
      // required String token,
      ) async {
    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    Map<String, dynamic> data = {};
    String url = '/posts/';
    int expectedStatusCode = 200;

    if (username != "") {
      url = '/posts/?u=${username}';
    }
    if (liked) {
      url += '&l=true';
    }

    try {
      data = await sendRequest(
        url: url,
        files: files,
        body: body,
        expectedStatusCode: expectedStatusCode,
        needHeader: true,
        Method: "GET",
      );
    } catch (e) {
      e as Map;
      throw e[e.keys.toList().first][0];
    }

    List<PostModel> posts = [];
    for (var obj in data['results']) {
      posts.add(PostModel.fromJson(obj));
    }

    return posts;
  }

  static Future<PostModel> postDetail({required int id}
      // required String token,
      ) async {
    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    Map<String, dynamic> data = {};
    String url = '/posts/detail/${id}/';
    int expectedStatusCode = 200;

    try {
      data = await sendRequest(
        url: url,
        files: files,
        body: body,
        expectedStatusCode: expectedStatusCode,
        needHeader: true,
        Method: "GET",
      );
    } catch (e) {
      e as Map;
      throw e[e.keys.toList().first][0];
    }

    PostModel post = PostModel.fromJson(data);

    return post;
  }

  Future addLike() async {
    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    Map<String, dynamic> data = {};
    String url = '/posts/like/add/';
    int expectedStatusCode = 201;
    var box = Hive.box('userBox');

    body['post'] = this.id.toString();
    body['user'] = box.get('id').toString();

    try {
      data = await sendRequest(
        url: url,
        files: files,
        body: body,
        expectedStatusCode: expectedStatusCode,
        needHeader: true,
        Method: "POST",
      );
    } catch (e) {
      e as Map;
      throw e[e.keys.toList().first][0];
    }

    return true;
  }

  Future removeLike() async {
    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    Map<String, dynamic> data = {};
    String url = '/posts/like/remove/${this.id}/';
    int expectedStatusCode = 204;

    try {
      data = await sendRequest(
        url: url,
        files: files,
        body: body,
        expectedStatusCode: expectedStatusCode,
        needHeader: true,
        Method: "DELETE",
      );
    } catch (e) {
      e as Map;
      throw e[e.keys.toList().first][0];
    }

    return true;
  }
}
