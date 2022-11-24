import 'package:grab_grub_app/models/userModel.dart';
import 'package:http/http.dart';

import 'sendRequest.dart';

class ConversationModel {
  static Future<List<UserModel>> getConversations() async {
    Iterable<MultipartFile> files = [];
    Map<String, String> body = {};
    String url = '/message/conversations/';
    Map<String, dynamic> data = {};
    int expectedStatusCode = 200;

    data = await sendRequest(
      url: url,
      files: files,
      body: body,
      expectedStatusCode: expectedStatusCode,
      needHeader: true,
      Method: "GET",
    );

    List<UserModel> conversations = [];
    for (var obj in data['results']) {
      obj['username'] = obj['to_username'];
      obj['email'] = obj['to_email'];
      obj['id'] = obj['to'];
      obj['image_url'] = obj['to_image'];
      conversations.add(UserModel.fromJson(obj));
    }

    return conversations;
  }
}
