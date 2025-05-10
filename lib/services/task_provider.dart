import 'package:flutter/foundation.dart';
import '../models/task.dart';
import 'storage_service.dart';

class TaskProvider with ChangeNotifier {
  final StorageService _storage = StorageService.instance;
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await _storage.getAllTasks();
    notifyListeners();
  }

  Future<Task> addTask(Task task) async {
    final newTask = await _storage.createTask(task);
    _tasks.add(newTask);
    notifyListeners();
    return newTask;
  }

  Future<void> updateTask(Task task) async {
    await _storage.updateTask(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    await _storage.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask);
  }
}