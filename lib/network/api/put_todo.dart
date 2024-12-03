import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/todo.dart';
import '../../utils/logger.dart';

Future<bool> updateTodo(Todo todo) async {
  final headers = <String, String>{
    'X-Parse-Application-Id': '9W1UK312ziUPPMWDo8GL9C6yCoPpT2Pd0yYYn9fL',
    'X-Parse-REST-API-Key': 'wymHp0JgaOnCw6fiX6RSnmaW8FYAhtSsAZObmgVQ',
    'Content-Type': 'application/json',
  };

  final requestBody = jsonEncode({"completed": !todo.completed});
  final response = await http.put(
    Uri.parse('https://parseapi.back4app.com/classes/Todo/${todo.objectId}'),
    headers: headers,
    body: requestBody
  );

  Logger.log('Put Request URL: https://parseapi.back4app.com/classes/Todo/${todo.objectId}');
  Logger.log('Put Request Body: $requestBody');
  Logger.log('Put Response Status: ${response.statusCode}');
  Logger.log('Put Response Body: ${response.body}');

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to update todo');
  }
}