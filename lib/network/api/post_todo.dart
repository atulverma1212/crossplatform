import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/todo.dart';
import '../../utils/logger.dart';

Future<bool> postTodo(Todo newTodo) async {
  final url = Uri.parse('https://parseapi.back4app.com/classes/Todo');
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'X-Parse-Application-Id': '9W1UK312ziUPPMWDo8GL9C6yCoPpT2Pd0yYYn9fL',
    'X-Parse-REST-API-Key': 'wymHp0JgaOnCw6fiX6RSnmaW8FYAhtSsAZObmgVQ',
  };
  final body = jsonEncode(newTodo.toJson());

  Logger.log('POST $url');
  Logger.log('Headers: $headers');
  Logger.log('Body: $body');

  final response = await http.post(url, headers: headers, body: body);

  Logger.log('Response Status: ${response.statusCode}');
  Logger.log('Response Body: ${response.body}');

  if (response.statusCode == 201 || response.statusCode == 200) {
    return true;
  } else {
    final errorMessage = json.decode(response.body)['message'];
    throw Exception(
        "${response.statusCode}: ${errorMessage ?? 'Failed to add todo'}");
  }
}

//add post api for login
Future<bool> postLogin(String username, String password) async {
  final url = Uri.parse('https://parseapi.back4app.com/login');
  final headers = <String, String>{
    'Content-Type': 'application/json',
    'X-Parse-Application-Id': '9W1UK312ziUPPMWDo8GL9C6yCoPpT2Pd0yYYn9fL',
    'X-Parse-REST-API-Key': 'wymHp0JgaOnCw6fiX6RSnmaW8FYAhtSsAZObmgVQ',
    'X-Parse-Revocable-Session': '1'
  };
  final body = jsonEncode({'username': username, 'password': password});

  Logger.log('POST $url');
  Logger.log('Headers: $headers');
  Logger.log('Body: $body');

  final response = await http.post(url, headers: headers, body: body);

  Logger.log('Response Status: ${response.statusCode}');
  Logger.log('Response Body: ${response.body}');

  if (response.statusCode == 201 || response.statusCode == 200) {
    return true;
  } else {
    final errorMessage = json.decode(response.body)['message'];
    throw Exception(
        "${response.statusCode}: ${errorMessage ?? 'Failed to login'}");
  }
}
