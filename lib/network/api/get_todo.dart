import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/todo.dart';
import '../../utils/logger.dart';

Future<List<Todo>> fetchTodoList() async {
  final headers = <String, String>{
    'X-Parse-Application-Id': '9W1UK312ziUPPMWDo8GL9C6yCoPpT2Pd0yYYn9fL',
    'X-Parse-REST-API-Key': 'wymHp0JgaOnCw6fiX6RSnmaW8FYAhtSsAZObmgVQ',
  };
  final response = await http.get(
      Uri.parse('https://parseapi.back4app.com/classes/Todo'),
      headers: headers);
  Logger.log('Response Status: ${response.statusCode}');
  Logger.log('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> todos = data['results'];
    return todos.map((json) => Todo.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load todos');
  }
}
