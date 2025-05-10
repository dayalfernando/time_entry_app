import 'package:flutter/foundation.dart';
import '../../models/task.dart';
import '../../models/task_status.dart';
import '../task_service.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _service = TaskService();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  List<Task> getTodaysTasks() {
    final now = DateTime.now();
    return _tasks.where((task) =>
      task.startTime.year == now.year &&
      task.startTime.month == now.month &&
      task.startTime.day == now.day
    ).toList();
  }

  Future<void> loadTasks() async {
    _tasks = await _service.getAllTasks();
    notifyListeners();
  }

  Future<Task> addTask(Task task) async {
    final newTask = await _service.createTask(task);
    _tasks.add(newTask);
    notifyListeners();
    return newTask;
  }

  Future<void> updateTask(Task task) async {
    await _service.updateTask(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    await _service.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  Future<void> startTask(Task task) async {
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
    return _service.getTasksForDate(date);
  }
}