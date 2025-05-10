import 'package:flutter/material.dart';
import '../models/user.dart';
import 'user_avatar.dart';

class UserProfileWidget extends StatelessWidget {
  final User? user;
  final double avatarSize;

  const UserProfileWidget({
    super.key,
    this.user,
    this.avatarSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UserAvatar(
          user: user,
          size: avatarSize,
        ),
        if (user != null) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user!.role.displayName,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }
} 