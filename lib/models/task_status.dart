import 'package:flutter/material.dart';

enum TaskStatus {
  pending,
  inProgress,
  completed;

  String get displayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  Color getStatusColor(BuildContext context) {
    switch (this) {
      case TaskStatus.pending:
        return Theme.of(context).colorScheme.primary.withOpacity(0.7);
      case TaskStatus.inProgress:
        return const Color(0xFFFFB800); // Gold color
      case TaskStatus.completed:
        return Colors.green;
    }
  }
} 