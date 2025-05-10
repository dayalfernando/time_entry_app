import '../models/task.dart';

class TaskService {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  final List<Task> _tasks = [];
  int _nextId = 1;

  Future<Task> createTask(Task task) async {
    final newTask = task.copyWith(id: _nextId++);
    _tasks.add(newTask);
    return newTask;
  }

  Future<List<Task>> getAllTasks() async {
    return List.from(_tasks);
  }

  Future<Task?> getTaskById(int id) async {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Task> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      return task;
    }
    throw Exception('Task not found');
  }

  Future<void> deleteTask(int id) async {
    _tasks.removeWhere((task) => task.id == id);
  }

  Future<List<Task>> getTasksForDate(DateTime date) async {
    return _tasks.where((task) => 
      task.date.year == date.year && 
      task.date.month == date.month && 
      task.date.day == date.day
    ).toList();
  }
} 