import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters for the View to consume
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch data from Supabase
  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Tells the UI to show a loading spinner

    try {
      final response = await _supabase.from('tasks').select();
      _tasks = (response as List).map((data) => Task.fromJson(data)).toList();
    } catch (e) {
      _errorMessage = "Failed to load tasks: $e";
    } finally {
      _isLoading = false;
      notifyListeners(); // Tells the UI to rebuild with the new data
    }
  }

  // Insert data into Supabase
  Future<void> addTask(String title) async {
    try {
      await _supabase.from('tasks').insert({
        'title': title, 
        'is_completed': false
      });
      await fetchTasks(); // Refresh the list
    } catch (e) {
      _errorMessage = "Failed to add task: $e";
      notifyListeners();
    }
  }
}