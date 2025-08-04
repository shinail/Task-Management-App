import 'package:flutter/material.dart';
import 'package:task_management/models/task_model.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF7C4DFF),
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF8F6FF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetail('Title', task.title),
            _buildDetail('Description', task.description),
            _buildDetail(
              'Due Date',
              task.dueDate.toLocal().toString().split(' ')[0],
            ),
            _buildDetail('Priority', task.priority),
            _buildDetail('Completed', task.isCompleted ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF7C4DFF),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
