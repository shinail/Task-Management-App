import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/viewmodels/task_viewmodel.dart';
import 'package:task_management/widgets/task_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskVM = Provider.of<TaskViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Task History')),
      body: StreamBuilder(
        stream: taskVM.getArchivedTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No history found.'));
          }

          final archivedTasks = snapshot.data!;

          return ListView.builder(
            itemCount: archivedTasks.length,
            itemBuilder: (context, index) {
              return TaskCard(task: archivedTasks[index]);
            },
          );
        },
      ),
    );
  }
}
