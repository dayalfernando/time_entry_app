import 'package:flutter/material.dart';
import '../../models/user.dart';

class NotificationProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _notifications = [];
  String? _currentUserId;

  List<Map<String, dynamic>> get notifications {
    if (_currentUserId == null) {
      // Admin sees all notifications
      return _notifications;
    }
    // Engineers only see their notifications
    return _notifications.where((n) => n['userId'] == _currentUserId).toList();
  }

  int get unreadCount => notifications.where((n) => !n['isRead']).length;

  void setCurrentUser(String? userId) {
    _currentUserId = userId;
    notifyListeners();
  }

  void addNotification(String title, String message, {String? userId}) {
    _notifications.insert(0, {
      'title': title,
      'message': message,
      'timestamp': DateTime.now(),
      'isRead': false,
      'userId': userId ?? _currentUserId,
    });
    notifyListeners();
  }

  void markAllAsRead() {
    final userNotifications = notifications; // Get filtered notifications
    for (var notification in userNotifications) {
      notification['isRead'] = true;
    }
    notifyListeners();
  }

  void clearNotifications() {
    if (_currentUserId == null) {
      // Admin can clear all notifications
      _notifications.clear();
    } else {
      // Engineers can only clear their notifications
      _notifications.removeWhere((n) => n['userId'] == _currentUserId);
    }
    notifyListeners();
  }
}