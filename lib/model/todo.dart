class Todo {
  final int userId;
  final String title;
  bool completed;
  String objectId = '';

  Todo({required this.userId, required this.title, required this.completed, required this.objectId});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'],
      title: json['todo'],
      completed: json['completed'],
      objectId: json['objectId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'todo': title, 'completed': completed, 'objectId': objectId};
  }
}
