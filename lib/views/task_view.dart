import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_viewmodel.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  @override
  void initState() {
    super.initState();
    // Fetch tasks as soon as the view loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskViewModel>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the ViewModel for changes
    final viewModel = context.watch<TaskViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Supabase MVVM Tasks')),
      body: _buildBody(viewModel),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.addTask("New Task at ${DateTime.now().second}s");
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(TaskViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(child: Text(viewModel.errorMessage!));
    }

    if (viewModel.tasks.isEmpty) {
      return const Center(child: Text("No tasks found."));
    }

    return ListView.builder(
      itemCount: viewModel.tasks.length,
      itemBuilder: (context, index) {
        final task = viewModel.tasks[index];
        return ListTile(
          title: Text(task.title),
          trailing: Icon(
            task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
            color: task.isCompleted ? Colors.green : Colors.grey,
          ),
        );
      },
    );
  }
}