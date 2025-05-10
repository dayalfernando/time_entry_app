import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_entry_screen.dart';
import 'task_start_checklist_screen.dart';
import 'task_completion_screen.dart';
import 'package:provider/provider.dart';
import '../services/providers/task_provider.dart';
import 'package:intl/intl.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final bool hasStarted = task.actualStartTime != null;
    final bool hasEnded = task.actualEndTime != null;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskEntryScreen(task: task),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Task'),
                  content: const Text('Are you sure you want to delete this task?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text('Delete'),
                      onPressed: () {
                        taskProvider.deleteTask(task.id!);
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to list
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              context,
              title: 'Client Information',
              content: task.clientName,
              icon: Icons.business,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Date & Time',
              content: '${_formatDate(task.date)}\n'
                  'Scheduled Start: ${_formatTime(task.startTime)}\n'
                  'Scheduled End: ${_formatTime(task.endTime)}'
                  '${hasStarted ? '\nActual Start: ${_formatDateTime(task.actualStartTime!)}' : ''}'
                  '${hasEnded ? '\nActual End: ${_formatDateTime(task.actualEndTime!)}' : ''}',
              icon: Icons.access_time,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Duration Details',
              content: 'Break Duration: ${task.breakDuration} minutes\n'
                  'Travel Time: ${task.travelTime} minutes\n'
                  'Total Work Time: ${_calculateWorkTime(task)} minutes',
              icon: Icons.timer,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Comments',
              content: task.comments.isEmpty ? 'No comments' : task.comments,
              icon: Icons.comment,
            ),
            const SizedBox(height: 24),
            if (!hasEnded) // Only show button if task hasn't ended
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasStarted
                        ? Theme.of(context).colorScheme.secondary // Gold color for End Task
                        : Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: Icon(
                    hasStarted ? Icons.stop_circle : Icons.play_circle_outline,
                  ),
                  label: Text(
                    hasStarted ? 'End Task' : 'Start Task',
                    style: const TextStyle(fontSize: 16),
                  ),
                  onPressed: hasStarted
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskCompletionScreen(task: task),
                            ),
                          );
                        }
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskStartChecklistScreen(task: task),
                            ),
                          );
                        },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y HH:mm').format(dateTime);
  }

  String _calculateWorkTime(Task task) {
    final difference = task.endTime.difference(task.startTime).inMinutes;
    return (difference - task.breakDuration).toString();
  }
}