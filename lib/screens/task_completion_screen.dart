import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/task.dart';
import '../services/providers/task_provider.dart';
import 'package:provider/provider.dart';

enum CompletionStatus {
  fullyCompleted,
  partiallyCompleted,
  blocked;

  String get displayName {
    switch (this) {
      case CompletionStatus.fullyCompleted:
        return 'Completed Fully';
      case CompletionStatus.partiallyCompleted:
        return 'Partially Completed';
      case CompletionStatus.blocked:
        return 'Blocked';
    }
  }

  Color getStatusColor(BuildContext context) {
    switch (this) {
      case CompletionStatus.fullyCompleted:
        return Colors.green;
      case CompletionStatus.partiallyCompleted:
        return Theme.of(context).colorScheme.secondary; // Gold
      case CompletionStatus.blocked:
        return Colors.red;
    }
  }
}

class TaskCompletionScreen extends StatefulWidget {
  final Task task;

  const TaskCompletionScreen({super.key, required this.task});

  @override
  State<TaskCompletionScreen> createState() => _TaskCompletionScreenState();
}

class _TaskCompletionScreenState extends State<TaskCompletionScreen> {
  final _notesController = TextEditingController();
  final _breakDurationController = TextEditingController();
  CompletionStatus _selectedStatus = CompletionStatus.fullyCompleted;
  bool _travelSameRoute = false;
  bool _travelDifferentRoute = false;
  final List<File> _images = [];
  final _imagePicker = ImagePicker();

  bool get _canEndTask {
    return (_travelSameRoute || _travelDifferentRoute) && 
           !(_travelSameRoute && _travelDifferentRoute); // Can't select both routes
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _images.add(File(image.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _breakDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Completion',
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
                      'Completion Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...CompletionStatus.values.map((status) => RadioListTile(
                      value: status,
                      groupValue: _selectedStatus,
                      onChanged: (CompletionStatus? value) {
                        if (value != null) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        }
                      },
                      title: Text(
                        status.displayName,
                        style: TextStyle(
                          color: status.getStatusColor(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
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
                      'Special Notes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _notesController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Enter any special notes or comments...',
                        border: OutlineInputBorder(),
                      ),
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
                      'Break Duration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _breakDurationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter break duration in minutes',
                        border: OutlineInputBorder(),
                        suffixText: 'minutes',
                      ),
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
                      'Task Images',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Take Photo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Upload Photo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    if (_images.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Stack(
                                children: [
                                  Image.file(
                                    _images[index],
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _removeImage(index),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
                      'Travel Options',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      value: _travelSameRoute,
                      onChanged: (value) {
                        setState(() {
                          _travelSameRoute = value;
                          if (value) {
                            _travelDifferentRoute = false;
                          }
                        });
                      },
                      title: const Text('Travel Back from Same Route'),
                      subtitle: Text(
                        _travelSameRoute ? 'Selected' : 'Not selected',
                        style: TextStyle(
                          color: _travelSameRoute 
                              ? theme.colorScheme.secondary 
                              : Colors.grey,
                        ),
                      ),
                      activeColor: theme.colorScheme.secondary,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(),
                    SwitchListTile(
                      value: _travelDifferentRoute,
                      onChanged: (value) {
                        setState(() {
                          _travelDifferentRoute = value;
                          if (value) {
                            _travelSameRoute = false;
                          }
                        });
                      },
                      title: const Text('Travel Back from Different Route'),
                      subtitle: Text(
                        _travelDifferentRoute ? 'Selected' : 'Not selected',
                        style: TextStyle(
                          color: _travelDifferentRoute 
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
                onPressed: _canEndTask
                    ? () async {
                        final taskProvider = Provider.of<TaskProvider>(
                          context, 
                          listen: false
                        );
                        // Parse break duration
                        final breakDuration = int.tryParse(_breakDurationController.text) ?? 0;
                        // TODO: Save images and other data
                        await taskProvider.endTask(
                          widget.task,
                          breakDuration: breakDuration,
                          notes: _notesController.text,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Task completed successfully'),
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
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  'End Task',
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