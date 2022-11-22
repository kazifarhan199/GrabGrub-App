import 'package:grab_grub_app/models/utils.dart/sendRequest.dart';
import 'package:http/http.dart';

class UserModel {
  String username;
  String token;

  UserModel({
    required this.username,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey(['username', 'token'])) {
      return throw ("Can't find user data");
    }
    return UserModel(
      username: json['username'],
      token: json['token'],
    );
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
    return user;
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

    data['username'] = username;
    data['email'] = email;
    UserModel user = UserModel.fromJson(data);
    return user;
  }
}
