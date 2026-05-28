import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../routes/app_routes.dart';
import '../widgets/menu_bar.dart';
import '../widgets/list_menu.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX Clean Base'),
        actions: const [ListMenu()],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("User Page", style: TextStyle(color: Colors.red, fontSize: 20)),
                IconButton(onPressed: () => Get.toNamed(AppRoutes.user), icon: Icon(Icons.arrow_forward)),

                Text("Detail Page", style: textTheme.headlineMedium),
                IconButton(onPressed: () => Get.toNamed(AppRoutes.detail), icon: Icon(Icons.arrow_forward)),

                const ListMenu(),
                IconButton(onPressed: controller.sum, icon: Icon(Icons.add)),
                const SizedBox(height: 16),

                const HomeMenuBar(),
                const SizedBox(height: 16),
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
                  icon: const Icon(CupertinoIcons.alarm),
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
                      borderRadius: BorderRadius.circular(20),
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
