import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 1. Fetch data from Supabase
  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Order by ID so newer tasks appear at the bottom
      final response = await _supabase.from('tasks').select().order('id', ascending: true);
      _tasks = (response as List).map((data) => Task.fromJson(data)).toList();
    } catch (e) {
      _errorMessage = "Failed to load tasks: $e";
    } finally {
      _isLoading = false;
      notifyListeners(); 
    }
  }

  // 2. Insert CUSTOM data into Supabase
  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) return; // Prevent empty tasks

    try {
      await _supabase.from('tasks').insert({
        'title': title.trim(), 
        'is_completed': false
      });
      await fetchTasks(); // Refresh the list from the database
    } catch (e) {
      _errorMessage = "Failed to add task: $e";
      notifyListeners();
    }
  }

  // 3. Delete SELECTED data from Supabase
  Future<void> deleteTask(int id) async {
    try {
      // Delete from database where the 'id' column equals the passed id
      await _supabase.from('tasks').delete().eq('id', id);
      
      // Remove it locally from the list so the UI updates instantly 
      // without needing to re-fetch the entire list from the server
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to delete task: $e";
      notifyListeners();
    }
  }
}