import 'package:flutter/foundation.dart';

enum UserRole {
  admin,
  engineer;

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.engineer:
        return 'Engineer';
    }
  }
}

class User {
  final String username;
  final String password; // In a real app, this would be hashed
  final UserRole role;
  final String fullName;

  const User({
    required this.username,
    required this.password,
    required this.role,
    required this.fullName,
  });

  // Dummy users for testing
  static const List<User> dummyUsers = [
    User(
      username: 'dayal.fernando',
      password: 'admin123',
      role: UserRole.admin,
      fullName: 'Dayal Fernando',
    ),
    User(
      username: 'john.smith',
      password: 'engineer123',
      role: UserRole.engineer,
      fullName: 'John Smith',
    ),
    User(
      username: 'sarah.wilson',
      password: 'engineer123',
      role: UserRole.engineer,
      fullName: 'Sarah Wilson',
    ),
  ];

  static User? authenticate(String username, String password) {
    try {
      return dummyUsers.firstWhere(
        (user) => user.username == username && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }
}