import 'dart:convert';
import 'package:grab_grub_app/staticVar.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

import 'isConnected.dart';

Future<Map<String, dynamic>> sendRequest({
  required String url,
  Iterable<MultipartFile> files = const [],
  Map<String, String> body = const {},
  required int expectedStatusCode,
  bool needHeader = true,
  required String Method,
}) async {
  var box = Hive.box('userBox');
  Map<String, String> headers = {};

  if (await isConnected() == false) throw ("No internet connection");

  if (needHeader) {
    headers['Authorization'] = 'Token ' + box.get('token');
  }

  Response response;
  print(url);
  print(staticVar.base_url + url);
  var uri = Uri.parse(staticVar.base_url + url);
  var request = MultipartRequest(Method, uri);
  request.fields.addAll(body);
  request.headers.addAll(headers);
  request.files.addAll(files);

  try {
    response = await Response.fromStream(await request.send());
  } catch (e) {
    throw e.toString();
  }

  Map<String, dynamic> data = {};
  try {
    data = jsonDecode(utf8.decode(response.bodyBytes));
  } on TypeError catch (e) {
    data['results'] = jsonDecode(utf8.decode(response.bodyBytes));
  } catch (e) {
    throw e.toString();
  }

  if (response.statusCode == expectedStatusCode) {
    return data;
  } else {
    throw data.toString();
  }
}
