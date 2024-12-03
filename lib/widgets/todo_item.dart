import 'package:flutter/material.dart';

import '../model/todo.dart';

class ToDoItem extends StatelessWidget {
  final Todo todoItem;
  final VoidCallback onToggleCompleted;
  final VoidCallback onDeletePressed;

  const ToDoItem(
      {super.key,
      required this.todoItem,
      required this.onToggleCompleted,
      required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onToggleCompleted,
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDeletePressed,
      ),
      leading: Icon(
          todoItem.completed ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.green),
      title: Text(todoItem.title,
          style: const TextStyle(fontSize: 18),
          maxLines: 2,
          overflow: TextOverflow.ellipsis),
    );
  }
}
