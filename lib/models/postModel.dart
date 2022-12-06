import 'package:grab_grub_app/models/utils.dart/sendRequest.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

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
  int servings;

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
    required this.servings,
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
      servings: json['servings'],
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

  static CreatePost(
      {required String title,
      required String description,
      required XFile? image,
      required int servings}) async {
    if (title == '') {
      throw "Please enter a title";
    }
    if (description == '') {
      throw "Please enter a description";
    }
    if (image == null) {
      throw "Please select an image";
    }
    if (servings <= 0) {
      throw "Please enter the number of servings";
    }

    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    Map<String, dynamic> data = {};
    String url = '/posts/create/';
    int expectedStatusCode = 201;
    var box = Hive.box('userBox');

    body['title'] = title;
    body['text'] = description;
    body['servings'] = servings.toString();
    body['user'] = box.get("id").toString();

    files = [
      (await MultipartFile.fromPath(
        'image',
        image.path,
      ))
    ];

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
      if (e[e.keys.toList().first][0] == 'This field is required.') {
        throw "${e.keys.toList().first} is required.";
      }
      throw e[e.keys.toList().first][0];
    }
  }
}
