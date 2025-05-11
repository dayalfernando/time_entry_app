import 'package:flutter/foundation.dart';
import '../../models/task.dart';
import '../../models/task_status.dart';
import '../task_service.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _service = TaskService();
  List<Task> _tasks = [];
  String? _currentUserId;

  List<Task> get tasks => _tasks;

  void setCurrentUser(String userId) {
    _currentUserId = userId.isEmpty ? null : userId; // Empty userId means admin access
    loadTasks(); // Reload tasks for the new user
  }

  List<Task> get todaysTasks {
    final now = DateTime.now();
    return _tasks
      .where((task) =>
        task.startTime.year == now.year &&
        task.startTime.month == now.month &&
        task.startTime.day == now.day &&
        (_currentUserId == null || task.userId == _currentUserId)
      )
      .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  Future<void> loadTasks() async {
    if (_currentUserId != null) {
      _tasks = await _service.getTasksForUser(_currentUserId!);
    } else {
      _tasks = await _service.getAllTasks(); // Admin gets all tasks
    }
    notifyListeners();
  }

  Future<Task> addTask(Task task) async {
    if (_currentUserId != null && task.userId != _currentUserId) {
      throw Exception('Cannot create tasks for other users');
    }
    final newTask = await _service.createTask(task);
    _tasks.add(newTask);
    notifyListeners();
    return newTask;
  }

  Future<void> updateTask(Task task) async {
    if (_currentUserId != null && task.userId != _currentUserId) {
      throw Exception('Cannot update tasks for other users');
    }
    await _service.updateTask(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    final task = _tasks.firstWhere((t) => t.id == id);
    if (_currentUserId != null && task.userId != _currentUserId) {
      throw Exception('Cannot delete tasks for other users');
    }
    await _service.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  Future<void> startTask(Task task) async {
    if (_currentUserId != null && task.userId != _currentUserId) {
      throw Exception('Cannot start tasks for other users');
    }
    final updatedTask = task.copyWith(
      actualStartTime: DateTime.now(),
      status: TaskStatus.inProgress,
      isCompleted: false,
    );
    await updateTask(updatedTask);
  }

  Future<void> endTask(
    Task task, {
    int? breakDuration,
    String? notes,
  }) async {
    if (_currentUserId != null && task.userId != _currentUserId) {
      throw Exception('Cannot end tasks for other users');
    }
    final updatedTask = task.copyWith(
      actualEndTime: DateTime.now(),
      status: TaskStatus.completed,
      isCompleted: true,
      breakDuration: breakDuration ?? task.breakDuration,
      comments: notes?.isNotEmpty == true ? notes : task.comments,
    );
    await updateTask(updatedTask);
  }

  Future<List<Task>> getTasksForDate(DateTime date) async {
    return _service.getTasksForDate(date, userId: _currentUserId);
  }
}