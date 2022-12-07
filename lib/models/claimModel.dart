import 'package:grab_grub_app/models/postModel.dart';
import 'package:grab_grub_app/models/utils.dart/sendRequest.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class ClaimModel {
  int id;
  String image;
  int post;
  int quantity;
  String text;

  ClaimModel({
    required this.id,
    required this.image,
    required this.post,
    required this.quantity,
    required this.text,
  });

  factory ClaimModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey(['username', 'token'])) {
      return throw ("Can't find user data");
    }
    return ClaimModel(
      id: json['id'],
      quantity: json['quantity'],
      image: json['image'] ?? "",
      post: json['post'] ?? 0,
      text: json['text'] ?? "",
    );
  }

  static Future<List<ClaimModel>> getClaims() async {
    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    String url = '/posts/claim/';
    Map<String, dynamic> data = {};
    int expectedStatusCode = 200;
    String method = 'GET';

    try {
      data = await sendRequest(
        url: url,
        files: files,
        body: body,
        expectedStatusCode: expectedStatusCode,
        needHeader: true,
        Method: method,
      );
    } catch (e) {
      e as Map;
      throw e[e.keys.toList().first][0];
    }
    print(data);

    List<ClaimModel> messages = [];
    for (var obj in data['results']) {
      messages.add(ClaimModel.fromJson(obj));
    }

    return messages;
  }

  static Future<ClaimModel> sendClaim(
      {required PostModel post, required int quantity}) async {
    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    String url = '/posts/claim/add/';
    Map<String, dynamic> data = {};
    int expectedStatusCode = 201;
    String method = 'POST';
    var box = Hive.box("userBox");

    if (quantity <= 0) {
      throw "Quantity needs to be more than 0";
    }
    if (post.servings < quantity) {
      throw "Not enough servings available";
    }

    body['post'] = post.id.toString();
    body['quantity'] = quantity.toString();
    body['user'] = box.get("id").toString();

    try {
      data = await sendRequest(
        url: url,
        files: files,
        body: body,
        expectedStatusCode: expectedStatusCode,
        needHeader: true,
        Method: method,
      );
    } catch (e) {
      e as Map;
      throw e[e.keys.toList().first][0];
    }

    ClaimModel claim = ClaimModel.fromJson(data);

    return claim;
  }
}
