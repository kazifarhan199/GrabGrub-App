import 'package:grab_grub_app/models/utils.dart/sendRequest.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class UserModel {
  int id;
  String username;
  String email;
  String token;
  String image;
  String bio;

  UserModel({
    required this.id,
    required this.username,
    required this.token,
    required this.image,
    required this.bio,
    required this.email,
  });

  factory UserModel.fromHive() {
    var box = Hive.box('userBox');
    return UserModel(
      id: box.get('id'),
      username: box.get('username'),
      token: box.get('token'),
      image: box.get('image'),
      bio: box.get('bio'),
      email: box.get('email'),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey(['username', 'token'])) {
      return throw ("Can't find user data");
    }
    return UserModel(
      id: json['id'],
      username: json['username'],
      token: json['token'] ?? "",
      image: json['image_url'],
      bio: json['bio'] ?? "",
      email: json['email'],
    );
  }

  static saveToHive(UserModel user) {
    var box = Hive.box('userBox');
    box.put('id', user.id);
    box.put('username', user.username);
    box.put('image', user.image);
    box.put('token', user.token);
    box.put('bio', user.bio);
    box.put('email', user.email);
  }

  static Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    String url = '/accounts/login/';
    Map<String, dynamic> data = {};
    int expectedStatusCode = 200;

    body['username'] = username;
    body['password'] = password;

    data = await sendRequest(
      url: url,
      files: files,
      body: body,
      expectedStatusCode: expectedStatusCode,
      needHeader: false,
      Method: "POST",
    );

    data['username'] = username;
    UserModel user = UserModel.fromJson(data);
    saveToHive(user);
    return user;
  }

  logout() async {
    UserModel user = UserModel(
        id: 0, username: "", token: "", image: "", bio: "", email: "");
    saveToHive(user);
  }

  static Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    String url = '/accounts/register/';
    Map<String, dynamic> data = {};
    int expectedStatusCode = 201;

    body['username'] = username;
    body['email'] = email;
    body['password'] = password;

    data = await sendRequest(
      url: url,
      files: files,
      body: body,
      expectedStatusCode: expectedStatusCode,
      needHeader: false,
      Method: "POST",
    );

    UserModel user = UserModel.fromJson(data);
    saveToHive(user);
    return user;
  }

  Future<UserModel> refreshProfile() async {
    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    String url = '/accounts/profile/${this.id}/';
    Map<String, dynamic> data = {};
    int expectedStatusCode = 200;
    bool needHeader = true;
    String method = "GET";

    data = await sendRequest(
      url: url,
      files: files,
      body: body,
      expectedStatusCode: expectedStatusCode,
      needHeader: needHeader,
      Method: method,
    );

    var box = Hive.box("userBox");
    if (this.id == box.get('id')) data['token'] = this.token;

    UserModel user = UserModel.fromJson(data);
    if (this.id == box.get('id')) saveToHive(user);
    return user;
  }

  static Future<UserModel> getProfile({required int userId}) async {
    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    String url = '/accounts/profile/${userId}/';
    Map<String, dynamic> data = {};
    int expectedStatusCode = 200;
    bool needHeader = true;
    String method = "GET";

    data = await sendRequest(
      url: url,
      files: files,
      body: body,
      expectedStatusCode: expectedStatusCode,
      needHeader: needHeader,
      Method: method,
    );

    UserModel user = UserModel.fromJson(data);
    return user;
  }

  Future<UserModel> editUser({
    required String username,
    required String bio,
    required String email,
    XFile? image,
  }) async {
    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    String url = '/accounts/profile-edit/';
    Map<String, dynamic> data = {};
    int expectedStatusCode = 200;
    bool needHeader = true;
    String method = "PUT";

    body['username'] = username;
    body['email'] = bio;
    body['email'] = email;

    if (image != null) {
      files = [
        (await MultipartFile.fromPath(
          'image',
          image.path,
        ))
      ];
    }

    data = await sendRequest(
        url: url,
        files: files,
        body: body,
        expectedStatusCode: expectedStatusCode,
        needHeader: needHeader,
        Method: method);

    data['token'] = this.token;

    UserModel user = UserModel.fromJson(data);
    saveToHive(user);

    print(user.email);
    print(user.username);
    print(user.image);
    return user;
  }
}
