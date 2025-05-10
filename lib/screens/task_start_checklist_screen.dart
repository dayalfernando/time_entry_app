import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/providers/task_provider.dart';
import 'package:provider/provider.dart';

class TaskStartChecklistScreen extends StatefulWidget {
  final Task task;

  const TaskStartChecklistScreen({super.key, required this.task});

  @override
  State<TaskStartChecklistScreen> createState() => _TaskStartChecklistScreenState();
}

class _TaskStartChecklistScreenState extends State<TaskStartChecklistScreen> {
  bool _isDressCodeChecked = false;
  bool _isToolsChecked = false;
  bool _isSafetyChecked = false;
  bool _isTravellingStarted = false;

  bool get _canStartTask {
    return _isDressCodeChecked && 
           _isToolsChecked && 
           _isSafetyChecked && 
           _isTravellingStarted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pre-Task Checklist',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: theme.colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Safety Checklist',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      value: _isDressCodeChecked,
                      onChanged: (value) {
                        setState(() {
                          _isDressCodeChecked = value ?? false;
                        });
                      },
                      title: const Text(
                        'Have you prepared for your work with appropriate Dress Code?',
                        style: TextStyle(fontSize: 14),
                      ),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const Divider(),
                    CheckboxListTile(
                      value: _isToolsChecked,
                      onChanged: (value) {
                        setState(() {
                          _isToolsChecked = value ?? false;
                        });
                      },
                      title: const Text(
                        'Have you borrowed necessary tools and equipment under the given safety standards?',
                        style: TextStyle(fontSize: 14),
                      ),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const Divider(),
                    CheckboxListTile(
                      value: _isSafetyChecked,
                      onChanged: (value) {
                        setState(() {
                          _isSafetyChecked = value ?? false;
                        });
                      },
                      title: const Text(
                        'Are you aware of the necessary safety precautions to be taken for this task?',
                        style: TextStyle(fontSize: 14),
                      ),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Travel Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      value: _isTravellingStarted,
                      onChanged: (value) {
                        setState(() {
                          _isTravellingStarted = value;
                        });
                      },
                      title: const Text('Start Travelling from the current Location'),
                      subtitle: Text(
                        _isTravellingStarted ? 'Travelling to location' : 'Not started',
                        style: TextStyle(
                          color: _isTravellingStarted 
                              ? theme.colorScheme.secondary 
                              : Colors.grey,
                        ),
                      ),
                      activeColor: theme.colorScheme.secondary,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _canStartTask
                    ? () async {
                        final taskProvider = Provider.of<TaskProvider>(
                          context, 
                          listen: false
                        );
                        await taskProvider.startTask(widget.task);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Task started successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context); // Go back to task details
                          Navigator.pop(context); // Go back to task list
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  disabledBackgroundColor: Colors.grey,
                ),
                icon: const Icon(Icons.play_circle_outline),
                label: const Text(
                  'Start Task',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 