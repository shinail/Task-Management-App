import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/models/task_model.dart';
import 'package:task_management/viewmodels/task_viewmodel.dart';
import 'package:task_management/views/dashboard/tasks/task_detail.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskVM = Provider.of<TaskViewModel>(context, listen: false);
    final date = DateFormat('yyyy-MM-dd').format(task.dueDate);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text('Due: $date'),
        trailing: Checkbox(
          value: task.isCompleted,
          onChanged: (val) {
            if (task.id != null) {
              taskVM.markCompleted(task.id!, val ?? false);
            }
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
          );
        },
        onLongPress: () async {
          if (task.id != null) {
            await taskVM.archiveTask(task.id!);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task moved to history')),
            );
          }
        },
      ),
    );
  }
}
