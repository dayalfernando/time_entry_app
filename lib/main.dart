import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/providers/task_provider.dart';
import 'services/providers/notification_provider.dart';
import 'services/providers/user_provider.dart';
import 'models/task.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/task_list_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/view_tasks_screen.dart';
import 'screens/task_entry_screen.dart';
import 'screens/task_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'UPSA Time Entry',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1B3764), // Deep Blue
            secondary: const Color(0xFFFFB800), // Gold
          ),
          useMaterial3: true,
        ),
        home: const LoginScreen(), // Start with login screen
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/calendar': (context) => const CalendarScreen(),
          '/tasks': (context) => const TaskListScreen(),
          '/view_tasks': (context) => const ViewTasksScreen(),
          '/add_task': (context) => const TaskEntryScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/task_details') {
            final task = settings.arguments as Task;
            return MaterialPageRoute(
              builder: (context) => TaskDetailsScreen(task: task),
            );
          }
          return null;
        },
      ),
    );
  }
}
