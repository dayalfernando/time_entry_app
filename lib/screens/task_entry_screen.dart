import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../services/providers/task_provider.dart';
import '../services/providers/notification_provider.dart';
import '../services/providers/user_provider.dart';
import 'task_list_screen.dart';
import '../widgets/app_drawer.dart';
import 'package:intl/intl.dart';

class TaskEntryScreen extends StatefulWidget {
  final Task? task;

  const TaskEntryScreen({super.key, this.task});

  @override
  State<TaskEntryScreen> createState() => _TaskEntryScreenState();
}

class _TaskEntryScreenState extends State<TaskEntryScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _submitForm() {
    if (_formKey.currentState!.saveAndValidate()) {
      final formData = _formKey.currentState!.value;
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

      final task = Task(
        id: widget.task?.id,
        clientName: formData['clientName'] as String,
        date: formData['date'] as DateTime,
        startTime: formData['startTime'] as DateTime,
        endTime: formData['endTime'] as DateTime,
        breakDuration: int.parse(formData['breakDuration'].toString()),
        travelTime: int.parse(formData['travelTime'].toString()),
        comments: formData['comments'] as String? ?? '',
        isCompleted: widget.task?.isCompleted ?? false,
        userId: userProvider.currentUser?.role == UserRole.admin 
          ? (formData['assignedUser'] as String? ?? userProvider.currentUser!.username)
          : userProvider.currentUser!.username,
      );
      
      if (widget.task == null) {
        taskProvider.addTask(task);
        
        // Add notification for new task
        notificationProvider.addNotification(
          'New Task Added',
          'Task for ${task.clientName} on ${DateFormat('MMM d, y').format(task.date)}'
        );
      } else {
        taskProvider.updateTask(task);
      }
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.task == null ? 'Task created successfully' : 'Task updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultStartTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      9, // 9 AM
      0, // 0 minutes
    );

    final defaultEndTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      17, // 5 PM
      0, // 0 minutes
    );

    final userProvider = Provider.of<UserProvider>(context);
    final isAdmin = userProvider.currentUser?.role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.task == null ? 'New Task' : 'Edit Task',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(currentRoute: 'task_entry'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          initialValue: widget.task == null
              ? {
                  'startTime': defaultStartTime,
                  'endTime': defaultEndTime,
                  'breakDuration': '30',
                  'travelTime': '30',
                  'assignedUser': userProvider.currentUser?.username,
                }
              : {
                  'clientName': widget.task!.clientName,
                  'date': widget.task!.date,
                  'startTime': widget.task!.startTime,
                  'endTime': widget.task!.endTime,
                  'breakDuration': widget.task!.breakDuration.toString(),
                  'travelTime': widget.task!.travelTime.toString(),
                  'comments': widget.task!.comments,
                  'assignedUser': widget.task!.userId,
                },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Client Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'clientName',
                        decoration: const InputDecoration(
                          labelText: 'Client Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.business),
                        ),
                        validator: FormBuilderValidators.required(),
                      ),
                      if (isAdmin) ...[
                        const SizedBox(height: 16),
                        FormBuilderDropdown<String>(
                          name: 'assignedUser',
                          decoration: const InputDecoration(
                            labelText: 'Assign To',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_assign),
                          ),
                          items: User.dummyUsers
                              .where((user) => user.role == UserRole.engineer)
                              .map((user) => DropdownMenuItem(
                                    value: user.username,
                                    child: Text('${user.fullName} (${user.username})'),
                                  ))
                              .toList(),
                          validator: FormBuilderValidators.required(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date & Time',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderDateTimePicker(
                        name: 'date',
                        inputType: InputType.date,
                        format: DateFormat('EEEE, MMMM d, yyyy'),
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderDateTimePicker(
                              name: 'startTime',
                              inputType: InputType.time,
                              format: DateFormat('HH:mm'),
                              decoration: const InputDecoration(
                                labelText: 'Start Time',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.access_time),
                              ),
                              validator: FormBuilderValidators.required(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FormBuilderDateTimePicker(
                              name: 'endTime',
                              inputType: InputType.time,
                              format: DateFormat('HH:mm'),
                              decoration: const InputDecoration(
                                labelText: 'End Time',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.access_time),
                              ),
                              validator: FormBuilderValidators.required(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Duration Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderTextField(
                              name: 'breakDuration',
                              decoration: const InputDecoration(
                                labelText: 'Break Duration (minutes)',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.timer),
                              ),
                              keyboardType: TextInputType.number,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.numeric(),
                                FormBuilderValidators.min(0),
                              ]),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FormBuilderTextField(
                              name: 'travelTime',
                              decoration: const InputDecoration(
                                labelText: 'Travel Time (minutes)',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.directions_car),
                              ),
                              keyboardType: TextInputType.number,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.numeric(),
                                FormBuilderValidators.min(0),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Additional Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'comments',
                        decoration: const InputDecoration(
                          labelText: 'Comments',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.comment),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _formKey.currentState?.reset();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        'Reset Form',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: Icon(widget.task == null ? Icons.add_circle : Icons.save),
                      label: Text(
                        widget.task == null ? 'Create Task' : 'Update Task',
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}