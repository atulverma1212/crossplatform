import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/network/async_loader.dart';

import '../network/api/delete_todo.dart';
import '../network/api/post_todo.dart';
import '../network/api/get_todo.dart';
import '../model/todo.dart';
import '../network/api/put_todo.dart';
import '../widgets/app_bar.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Todo>> futureTodoList;

  @override
  void initState() {
    super.initState();
    futureTodoList = fetchTodoList();
  }

  void _toggleCompleted(Todo todo) async {
    try {
      final result = await updateTodo(todo);
      if (result) {
        setState(() {
          todo.completed = !todo.completed;
        });
      }
    } catch (e) {
      // Handle error
      setState(() {
        todo.completed = !todo.completed; // Revert state on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: buildAppBar("All ToDos", false),
      body: Center(
        child: Column(
          children: [Expanded(child: _buildTodoList())],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        backgroundColor: buttonColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTodoList() {
    return AsyncLoader<List<Todo>>(
        future: futureTodoList,
        builder: (context, data) {
          return ListView(
            children: [
              // Container(
              //   margin: const EdgeInsets.only(
              //       top: 30, bottom: 40, left: 20, right: 20),
              //   child: const Text(
              //     "All ToDos",
              //     style: TextStyle(
              //         color: Colors.black87,
              //         fontSize: 30,
              //         fontWeight: FontWeight.bold),
              //   ),
              // ),
              ...data.map((todo) => Column(children: [
                    const SizedBox(height: 10),
                    ToDoItem(
                      todoItem: todo,
                      onToggleCompleted: () => _toggleCompleted(todo),
                      onDeletePressed: () => _deleteTodoItem(todo),
                    ),
                  ]))
            ],
          );
        });
  }

  void _addTodo() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController titleController = TextEditingController();
        return AlertDialog(
          title: const Text('Add New ToDo'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (titleController.text.isEmpty) {
                  return;
                }
                final String title = titleController.text;
                final newTodo = Todo(
                  userId: 123,
                  title: title,
                  completed: false,
                  objectId: '',
                );
                _addNewTodoItem(newTodo, context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addNewTodoItem(Todo newTodo, BuildContext newTodoDialogContext) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AsyncLoader<bool>(
              future: postTodo(newTodo),
              builder: (context, success) {
                if (success) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      futureTodoList = fetchTodoList();
                    });
                  });
                  Navigator.of(newTodoDialogContext).pop();
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Failed to add new todo'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  });
                }
                Navigator.of(context).pop();
                return const SizedBox.shrink();
              },
              errorBuilder: (context, error) {
                Navigator.of(newTodoDialogContext).pop();
                return const SizedBox.shrink();
              });
        });
  }

  void _deleteTodoItem(Todo todo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete ToDo'),
          content: const Text('Are you sure you want to delete this ToDo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteTodoItemFromServer(todo);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTodoItemFromServer(Todo todo) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AsyncLoader<bool>(
            future: deleteTodoItem(todo),
            builder: (context, success) {
              if (success) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    futureTodoList = fetchTodoList();
                  });
                  Navigator.of(context).pop();
                });
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Failed to delete, please retry'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                });
              }
              Navigator.of(context).pop();
              return const SizedBox.shrink();
            },
          );
        });
  }
}
