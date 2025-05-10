import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String tasksKey = 'tasks';
  static final StorageService instance = StorageService._init();
  SharedPreferences? _prefs;
  List<Task> _tasks = [];
  int _nextId = 1;

  StorageService._init();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final tasksJson = _prefs?.getString(tasksKey);
    if (tasksJson != null) {
      final List<dynamic> tasksList = jsonDecode(tasksJson);
      _tasks = tasksList.map((json) => Task.fromMap(json as Map<String, dynamic>)).toList();
      _nextId = _tasks.isEmpty ? 1 : _tasks.map((t) => t.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  Future<void> _saveTasks() async {
    final tasksJson = jsonEncode(_tasks.map((t) => t.toMap()).toList());
    await _prefs?.setString(tasksKey, tasksJson);
  }

  Future<Task> createTask(Task task) async {
    final newTask = task.copyWith(id: _nextId++);
    _tasks.add(newTask);
    await _saveTasks();
    return newTask;
  }

  Future<List<Task>> getAllTasks() async {
    if (_prefs == null) {
      await init();
    }
    return _tasks;
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await _saveTasks();
    }
  }

  Future<void> deleteTask(int id) async {
    _tasks.removeWhere((task) => task.id == id);
    await _saveTasks();
  }
}