import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/providers/task_provider.dart';
import '../services/providers/user_provider.dart';
import '../services/providers/notification_provider.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../widgets/user_avatar.dart';
import '../widgets/company_logo.dart';
import '../models/week_data.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_header.dart';
import '../models/task_status.dart';
import 'task_entry_screen.dart';
import 'task_details_screen.dart';
import 'package:intl/intl.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    final primaryColor = const Color(0xFF1B3764); // UPSA deep blue
    final accentColor = const Color(0xFFFFB800); // UPSA gold

    return Scaffold(
      appBar: AppHeader(
        title: 'UPSA Time Entry',
        additionalActions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                if (notificationProvider.unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        notificationProvider.unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              // Show notifications
            },
          ),
          PopupMenuButton<String>(
            offset: const Offset(0, 40),
            icon: const UserAvatar(
              user: User(
                username: 'john.doe',
                password: 'dummy123',
                role: UserRole.engineer,
                fullName: 'John Doe',
              ),
              size: 32,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel', style: TextStyle(color: primaryColor)),
                        ),
                        TextButton(
                          onPressed: () {
                            Provider.of<UserProvider>(context, listen: false).logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (route) => false,
                            );
                          },
                          child: Text('Logout', style: TextStyle(color: primaryColor)),
                        ),
                      ],
                    );
                  },
                );
              } else if (value == 'settings') {
                // TODO: Navigate to settings screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings coming soon!')),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person_outline, color: primaryColor),
                  title: Text(
                    'John Doe',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  subtitle: const Text('Engineer'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Settings'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/home'),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primaryColor.withOpacity(0.1),
                  Colors.white,
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today's Tasks Section
                    Text(
                      "Today's Tasks",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 85,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: taskProvider.todaysTasks.isEmpty ? 1 : taskProvider.todaysTasks.length,
                        itemBuilder: (context, index) {
                          if (taskProvider.todaysTasks.isEmpty) {
                            return Container(
                              width: MediaQuery.of(context).size.width - 48,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.grey[400],
                                    size: 20,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'No tasks scheduled for today',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final task = taskProvider.todaysTasks[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetailsScreen(task: task),
                                ),
                              );
                            },
                            child: Container(
                              width: 200,
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: task.status == TaskStatus.completed
                                      ? Colors.green.withOpacity(0.2)
                                      : task.status == TaskStatus.inProgress
                                          ? accentColor.withOpacity(0.2)
                                          : primaryColor.withOpacity(0.2),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    task.clientName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: primaryColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${DateFormat('HH:mm').format(task.startTime)}',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: task.status == TaskStatus.completed
                                              ? Colors.green.withOpacity(0.1)
                                              : task.status == TaskStatus.inProgress
                                                  ? accentColor.withOpacity(0.1)
                                                  : primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          task.status.displayName,
                                          style: TextStyle(
                                            color: task.status == TaskStatus.completed
                                                ? Colors.green
                                                : task.status == TaskStatus.inProgress
                                                    ? accentColor
                                                    : primaryColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Maintenance Image Section
                    Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/upsa_maintenance.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: primaryColor.withOpacity(0.1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.engineering,
                                        size: 64,
                                        color: primaryColor.withOpacity(0.5),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'UPSA',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    primaryColor.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                            const Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Text(
                                'Power Generation Excellence',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskEntryScreen(),
            ),
          );
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<WeekData> _groupTasksByWeek(List<Task> tasks) {
    if (tasks.isEmpty) return [];

    // Sort tasks by date
    final sortedTasks = List<Task>.from(tasks)
      ..sort((a, b) => b.date.compareTo(a.date));

    final Map<String, List<Task>> weekMap = {};

    for (var task in sortedTasks) {
      // Find the Monday of the week
      final taskDate = task.date;
      final monday = taskDate.subtract(Duration(days: taskDate.weekday - 1));
      
      // Create week label
      final weekLabel = _getWeekLabel(monday);
      
      if (!weekMap.containsKey(weekLabel)) {
        weekMap[weekLabel] = [];
      }
      weekMap[weekLabel]!.add(task);
    }

    // Convert to list of WeekData
    return weekMap.entries.map((entry) {
      final monday = entry.value.first.date.subtract(
        Duration(days: entry.value.first.date.weekday - 1)
      );
      final isCurrentWeek = _isCurrentWeek(monday);

      return WeekData(
        weekLabel: entry.key,
        tasks: entry.value,
        isCurrentWeek: isCurrentWeek,
      );
    }).toList();
  }

  String _getWeekLabel(DateTime monday) {
    final month = DateFormat('MMMM').format(monday);
    final weekNumber = ((monday.day - 1) ~/ 7) + 1;
    final suffix = _getWeekSuffix(weekNumber);
    return '$month $weekNumber$suffix Week';
  }

  String _getWeekSuffix(int weekNumber) {
    if (weekNumber >= 11 && weekNumber <= 13) return 'th';
    switch (weekNumber % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  bool _isCurrentWeek(DateTime date) {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final nextMonday = monday.add(const Duration(days: 7));
    return date.isAfter(monday.subtract(const Duration(days: 1))) && 
           date.isBefore(nextMonday);
  }
}