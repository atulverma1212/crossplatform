import 'package:flutter/material.dart';

class AsyncLoader<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext, T) builder;
  final Widget Function(BuildContext, Object?)? errorBuilder;

  const AsyncLoader({
    super.key,
    required this.future,
    required this.builder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          if (errorBuilder != null) {
            return errorBuilder!(context, snapshot.error);
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text(snapshot.error.toString()),
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
          return const SizedBox.shrink();
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data found'));
        } else {
          return builder(context, snapshot.data as T);
        }
      },
    );
  }
}
