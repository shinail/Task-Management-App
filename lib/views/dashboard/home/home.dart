import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/models/task_model.dart';
import 'package:task_management/viewmodels/task_viewmodel.dart';
import 'package:task_management/views/dashboard/tasks/add_tasks.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String getFormattedDate() {
    final now = DateTime.now();
    return DateFormat('EEEE, MMMM d').format(now);
  }

  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.deepOrange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskVM = Provider.of<TaskViewModel>(context, listen: false);

    final backgroundColor = const Color(0xFFF5F3FF);
    final cardColor = Colors.white;
    final primaryPurple = const Color(0xFF6A1B9A);
    final lightPurple = const Color(0xFFD1C4E9);
    final progressColor = const Color(0xFF8E24AA);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Your Tasks'),
        backgroundColor: Colors.white,
        foregroundColor: primaryPurple,
        elevation: 1,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<TaskModel>>(
          stream: taskVM.getTasks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final tasks = snapshot.data ?? [];
            final totalTasks = tasks.length;
            final completedTasks =
                tasks.where((task) => task.isCompleted).length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getFormattedDate(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryPurple,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value:
                            totalTasks == 0 ? 0 : completedTasks / totalTasks,
                        minHeight: 10,
                        backgroundColor: lightPurple.withOpacity(0.3),
                        color: progressColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      const SizedBox(height: 10),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          '$completedTasks of $totalTasks completed',
                          key: ValueKey('$completedTasks of $totalTasks'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Task List",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryPurple,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child:
                      tasks.isEmpty
                          ? const Center(
                            child: Text(
                              "No tasks available.",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                          : ListView.builder(
                            itemCount: totalTasks,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  onTap: () {
                                    // To be used for task details screen
                                  },
                                  leading: Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    activeColor: primaryPurple,
                                    value: task.isCompleted,
                                    onChanged: (val) {
                                      if (task.id != null) {
                                        taskVM.markCompleted(
                                          task.id!,
                                          val ?? false,
                                        );
                                      }
                                    },
                                  ),
                                  title: Text(
                                    task.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      decoration:
                                          task.isCompleted
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        'Due: ${task.dueDate.toLocal().toString().split(' ')[0]}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: getPriorityColor(
                                                task.priority,
                                              ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              task.priority.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: getPriorityColor(
                                                  task.priority,
                                                ),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      if (task.id != null) {
                                        taskVM.archiveTask(
                                          task.id!,
                                          task.dueDate!,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryPurple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
