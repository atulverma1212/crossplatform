import '../../model/todo.dart';
import 'package:http/http.dart' as http;

import '../../utils/logger.dart';

Future<bool> deleteTodoItem(Todo todo) async {
  final url = Uri.parse('https://parseapi.back4app.com/classes/Todo/${todo.objectId}');
  final headers = <String, String>{
    'X-Parse-Application-Id': '9W1UK312ziUPPMWDo8GL9C6yCoPpT2Pd0yYYn9fL',
    'X-Parse-REST-API-Key': 'wymHp0JgaOnCw6fiX6RSnmaW8FYAhtSsAZObmgVQ',
  };
  final response = await http.delete(url, headers: headers);

  Logger.log('Delete Request URL: https://parseapi.back4app.com/classes/Todo/${todo.objectId}');
  Logger.log('Delete Response Status: ${response.statusCode}');
  Logger.log('Delete Response Body: ${response.body}');

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to delete todo');
  }
}
