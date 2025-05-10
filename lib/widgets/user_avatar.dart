import 'package:flutter/material.dart';
import '../models/user.dart';

class UserAvatar extends StatelessWidget {
  final User? user;
  final double size;

  const UserAvatar({
    super.key,
    this.user,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: _buildAvatarContent(context),
    );
  }

  Widget _buildAvatarContent(BuildContext context) {
    if (user == null) {
      return _buildInitials(context, '?');
    }

    return _buildInitials(context, user!.fullName);
  }

  Widget _buildInitials(BuildContext context, String text) {
    final initial = text.isNotEmpty ? text[0].toUpperCase() : '?';
    return Text(
      initial,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
        fontSize: size * 0.5,
      ),
    );
  }
}