import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_viewmodel.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  // Controller to capture custom user input
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskViewModel>().fetchTasks();
    });
  }

  @override
  void dispose() {
    _taskController.dispose(); // Always dispose controllers to prevent memory leaks
    super.dispose();
  }

  // Dialog box to get custom data from the user
  void _showAddTaskDialog(BuildContext context, TaskViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              hintText: 'e.g., Buy groceries',
              border: OutlineInputBorder(),
            ),
            autofocus: true, // Opens keyboard automatically
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                viewModel.addTask(_taskController.text); // Send custom data to ViewModel
                _taskController.clear(); // Clear the text field
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Add Task'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TaskViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Supabase MVVM Tasks')),
      body: _buildBody(viewModel),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, viewModel),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(TaskViewModel viewModel) {
    if (viewModel.isLoading && viewModel.tasks.isEmpty) {
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
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: Icon(
              task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
              color: task.isCompleted ? Colors.green : Colors.grey,
            ),
            title: Text(task.title),
            
            // Delete Button assigned to the specific task ID
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                // Call the delete method on the ViewModel
                viewModel.deleteTask(task.id);
                
                // Optional: Show a quick snackbar confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Task deleted'), 
                    duration: Duration(seconds: 1)
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}