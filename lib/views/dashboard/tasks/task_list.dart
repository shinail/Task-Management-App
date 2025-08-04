import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/models/task_model.dart';
import 'package:task_management/viewmodels/task_viewmodel.dart';
import 'package:task_management/widgets/task_card.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskVM = Provider.of<TaskViewModel>(context, listen: false);

    final backgroundColor = const Color(0xFFF7F9F9);
    final accentColor = const Color(0xFF6B4C9A); // Light purple

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('All Tasks'),
        backgroundColor: Colors.white,
        foregroundColor: accentColor,
        elevation: 1,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<List<TaskModel>>(
          stream: taskVM.getTasks(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final tasks = snap.data ?? [];
            if (tasks.isEmpty) {
              return const Center(
                child: Text(
                  'No tasks yet',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            return ListView.separated(
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => TaskCard(task: tasks[i]),
            );
          },
        ),
      ),
    );
  }
}
