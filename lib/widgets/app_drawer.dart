import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.currentRoute,
  });

  void _navigateToRoute(BuildContext context, String route) {
    Navigator.pop(context); // Close drawer first
    if (currentRoute != route) {
      if (route == '/home') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
      } else {
        Navigator.pushNamed(context, route);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              image: DecorationImage(
                image: const AssetImage('assets/images/upsa_maintenance.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.primary.withOpacity(0.7),
                  BlendMode.srcOver,
                ),
                onError: (exception, stackTrace) => null,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'United Power',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Systems Australia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Time Entry System',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home_outlined,
                  title: 'Home',
                  route: '/home',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.calendar_month_outlined,
                  title: 'Calendar',
                  route: '/calendar',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.view_week_outlined,
                  title: 'Weekly Tasks',
                  route: '/tasks',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.list_alt_outlined,
                  title: 'View Tasks',
                  route: '/view_tasks',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '© 2024 United Power Systems Australia',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final theme = Theme.of(context);
    final isSelected = currentRoute == route;

    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: isSelected ? theme.colorScheme.primary : Colors.grey[700],
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? theme.colorScheme.primary : Colors.grey[900],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          tileColor: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : null,
          onTap: () => _navigateToRoute(context, route),
        ),
        const Divider(height: 1),
      ],
    );
  }
} 