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
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFFFB800), // UPSA gold
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.white,
        child: _buildAvatarContent(context),
      ),
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
        color: const Color(0xFF1B3764), // UPSA deep blue
        fontWeight: FontWeight.bold,
        fontSize: size * 0.4,
      ),
    );
  }
}