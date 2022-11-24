import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import 'utils.dart/sendRequest.dart';

class MessageModel {
  int id;
  String senderUsername, receiverUsername;
  int senderId, receiverId;
  String text;
  String postImage, image;
  int post;

  MessageModel({
    required this.id,
    required this.senderUsername,
    required this.receiverUsername,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.image,
    required this.postImage,
    required this.post,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey(['username', 'token'])) {
      return throw ("Can't find user data");
    }
    return MessageModel(
      id: json['id'],
      senderUsername: json['user_username'],
      receiverUsername: json['to_username'],
      senderId: json['user'],
      receiverId: json['to'],
      text: json['text'],
      image: json['image'] ?? "",
      postImage: json['post_image'] ?? "",
      post: json['post'] ?? 0,
    );
  }

  static Future<List<MessageModel>> getMessages(int id) async {
    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    String url = '/message/list/${id}/';
    Map<String, dynamic> data = {};
    int expectedStatusCode = 200;
    String method = 'GET';

    data = await sendRequest(
      url: url,
      files: files,
      body: body,
      expectedStatusCode: expectedStatusCode,
      needHeader: true,
      Method: method,
    );

    List<MessageModel> messages = [];
    for (var obj in data['results']) {
      messages.add(MessageModel.fromJson(obj));
    }

    return messages;
  }

  static Future<MessageModel> sendMessage(
      {String text = "", required int toUserId, XFile? image = null}) async {
    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    String url = '/message/create/';
    Map<String, dynamic> data = {};
    int expectedStatusCode = 201;
    String method = 'POST';

    body['text'] = text;
    body['to'] = toUserId.toString();

    if (image != null) {
      files = [
        (await MultipartFile.fromPath(
          'image',
          image.path,
        ))
      ];
    }

    print(image);

    data = await sendRequest(
      url: url,
      files: files,
      body: body,
      expectedStatusCode: expectedStatusCode,
      needHeader: true,
      Method: method,
    );

    MessageModel message = MessageModel.fromJson(data);

    return message;
  }
}