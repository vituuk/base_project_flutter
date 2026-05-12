import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('GetX Clean Base')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'You have pushed the button this many times:',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Text(
                    '${controller.count}',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: controller.loadTodo,
                  icon: const Icon(Icons.cloud_download_outlined),
                  label: const Text('Load API Todo'),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  if (controller.isLoadingTodo) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final error = controller.todoError;
                  if (error != null) {
                    return Text(
                      error,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }

                  final todo = controller.todo;
                  if (todo == null) {
                    return Text(
                      'No API data loaded yet.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium,
                    );
                  }

                  return DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Todo #${todo.id}',
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(todo.title),
                          const SizedBox(height: 8),
                          Text('Completed: ${todo.completed}'),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
