import 'package:flutter/foundation.dart';
import '../../models/task.dart';
import '../../models/task_status.dart';
import '../task_service.dart';
import '../notification_provider.dart';
import 'package:intl/intl.dart';

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
    // For admin users, ensure the task has a valid userId
    if (_currentUserId == null && (task.userId.isEmpty || task.userId == 'admin')) {
      throw Exception('Admin must assign task to an engineer');
    }
    
    // For engineers, ensure they can only create tasks for themselves
    if (_currentUserId != null && task.userId != _currentUserId) {
      throw Exception('Cannot create tasks for other users');
    }

    final newTask = await _service.createTask(task);
    _tasks.add(newTask);
    
    // Add notification for the assigned user
    final notificationProvider = NotificationProvider();
    if (_currentUserId == null) {
      // Admin creating task for engineer
      notificationProvider.addNotification(
        'New Task Assigned',
        'Task for ${task.clientName} on ${DateFormat('MMM d, y').format(task.date)}',
        userId: task.userId,
      );
    } else {
      // Engineer creating their own task
      notificationProvider.addNotification(
        'New Task Created',
        'Task for ${task.clientName} on ${DateFormat('MMM d, y').format(task.date)}',
      );
    }
    
    notifyListeners();
    return newTask;
  }

  Future<void> updateTask(Task task) async {
    // For admin users, ensure the task has a valid userId
    if (_currentUserId == null && (task.userId.isEmpty || task.userId == 'admin')) {
      throw Exception('Admin must assign task to an engineer');
    }
    
    // For engineers, ensure they can only update their own tasks
    if (_currentUserId != null && task.userId != _currentUserId) {
      throw Exception('Cannot update tasks for other users');
    }

    await _service.updateTask(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      final oldTask = _tasks[index];
      _tasks[index] = task;
      
      // Add notification if task assignment changed
      if (_currentUserId == null && oldTask.userId != task.userId) {
        final notificationProvider = NotificationProvider();
        notificationProvider.addNotification(
          'Task Reassigned',
          'Task for ${task.clientName} has been assigned to you',
          userId: task.userId,
        );
      }
      
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