import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _notifications = [];

  List<Map<String, dynamic>> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n['isRead']).length;

  void addNotification(String title, String message) {
    _notifications.insert(0, {
      'title': title,
      'message': message,
      'timestamp': DateTime.now(),
      'isRead': false,
    });
    notifyListeners();
  }

  void markAllAsRead() {
    for (var notification in _notifications) {
      notification['isRead'] = true;
    }
    notifyListeners();
  }
}