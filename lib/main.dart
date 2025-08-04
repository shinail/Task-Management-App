import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/viewmodels/auth_viewmodel.dart';
import 'package:task_management/viewmodels/task_viewmodel.dart';
import 'package:task_management/views/auth/forgot_password.dart';
import 'package:task_management/views/auth/login.dart';
import 'package:task_management/views/auth/signup.dart';
import 'package:task_management/views/dashboard/profile/profile.dart';
import 'package:task_management/views/dashboard/tasks/add_tasks.dart';
import 'package:task_management/views/dashboard/user_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/forgot': (context) => ForgotPasswordScreen(),
          '/home': (context) => UserDashboard(),
          '/profile': (context) => ProfileScreen(),
          '/addtask': (context) => AddTaskScreen(),
        },
      ),
    );
  }
}
