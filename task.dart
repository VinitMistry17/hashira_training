class Task {
  final String id;
  final String title;
  bool isDone;
  String? notes;

  Task({required this.id, required this.title, this.isDone = false,this.notes});
}
