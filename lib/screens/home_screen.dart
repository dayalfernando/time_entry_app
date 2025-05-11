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
          PopupMenuButton<void>(
            offset: const Offset(0, 40),
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
            onCanceled: () {
              // Mark all as read when dropdown is closed
              notificationProvider.markAllAsRead();
            },
            itemBuilder: (context) => [
              PopupMenuItem<void>(
                enabled: false,
                child: SizedBox(
                  width: 320,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Notifications',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            if (notificationProvider.unreadCount > 0)
                              TextButton(
                                onPressed: () {
                                  notificationProvider.markAllAsRead();
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                ),
                                child: Text(
                                  'Mark all as read',
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (notificationProvider.notifications.isEmpty)
                PopupMenuItem<void>(
                  enabled: false,
                  height: 100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none_outlined,
                          size: 32,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No notifications yet',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...notificationProvider.notifications.map((notification) {
                  return PopupMenuItem<void>(
                    height: 80,
                    enabled: false,
                    child: Container(
                      decoration: BoxDecoration(
                        color: notification['isRead']
                            ? Colors.white
                            : primaryColor.withOpacity(0.05),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            notification['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification['message'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatTimestamp(notification['timestamp']),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
            ],
          ),
          PopupMenuButton<String>(
            offset: const Offset(0, 40),
            icon: UserAvatar(
              user: userProvider.currentUser,
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
                    userProvider.currentUser?.fullName ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  subtitle: Text(
                    userProvider.currentUser?.role.displayName ?? '',
                  ),
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
                          return _buildTaskCard(context, task);
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

  Widget _buildTaskCard(BuildContext context, Task task) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isAdmin = userProvider.currentUser?.role == UserRole.admin;
    
    String getAssignedUserName(String userId) {
      final user = User.dummyUsers.firstWhere(
        (user) => user.username == userId,
        orElse: () => const User(
          username: '',
          password: '',
          role: UserRole.engineer,
          fullName: 'Unknown User',
        ),
      );
      return user.fullName;
    }

    Color getStatusColor() {
      switch (task.status) {
        case TaskStatus.pending:
          return Colors.grey;
        case TaskStatus.inProgress:
          return theme.colorScheme.secondary; // Gold color
        case TaskStatus.completed:
          return Colors.green;
      }
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailsScreen(task: task),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.clientName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (isAdmin) ...[
                          Text(
                            'Assigned to: ${getAssignedUserName(task.userId)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          '${_formatTime(task.startTime)} - ${_formatTime(task.endTime)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: getStatusColor(),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      task.status.name,
                      style: TextStyle(
                        color: getStatusColor(),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(timestamp);
    }
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
}