class Task {
  final int id;
  final String title;
  final bool isCompleted;

  Task({required this.id, required this.title, required this.isCompleted});

  // Factory method to map Supabase JSON response to Dart object
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isCompleted: json['is_completed'],
    );
  }
}