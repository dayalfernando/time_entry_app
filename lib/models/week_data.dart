import 'task.dart';

class WeekData {
  final String weekLabel;
  final List<Task> tasks;
  final bool isCurrentWeek;

  WeekData({
    required this.weekLabel,
    required this.tasks,
    required this.isCurrentWeek,
  });
}