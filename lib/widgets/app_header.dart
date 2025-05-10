import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/providers/user_provider.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? additionalActions;

  const AppHeader({
    super.key,
    required this.title,
    this.additionalActions,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.primary,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              'assets/logo/upsa_logo.png',
              height: 40,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'United Power',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              const Text(
                'Systems Australia',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (additionalActions != null) ...additionalActions!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 