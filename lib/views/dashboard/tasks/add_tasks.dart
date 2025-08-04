import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/models/task_model.dart';
import 'package:task_management/viewmodels/task_viewmodel.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedPriority = 'Medium';
  final _formKey = GlobalKey<FormState>();

  void _submitTask() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final newTask = TaskModel(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        dueDate: _selectedDate!,
        priority: _selectedPriority,
        isCompleted: false,
      );

      Provider.of<TaskViewModel>(context, listen: false).addTask(newTask);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task added successfully')));
      Navigator.pop(context);
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a due date')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final purple = const Color(0xFFB39DDB); // Light purple

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        backgroundColor: purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Create a Task",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Enter title'
                            : null,
              ),
              const SizedBox(height: 15),

              // Description
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 15),

              // Due Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _selectedDate == null
                      ? 'Pick Due Date'
                      : 'Due Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 16),
                ),
                leading: const Icon(Icons.calendar_today),
                trailing: ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  child: const Text("Select"),
                ),
              ),
              const SizedBox(height: 15),

              // Priority
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  prefixIcon: const Icon(Icons.flag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items:
                    ['High', 'Medium', 'Low']
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                onChanged: (val) => setState(() => _selectedPriority = val!),
              ),
              const SizedBox(height: 25),

              // Submit Button
              ElevatedButton.icon(
                onPressed: _submitTask,
                icon: const Icon(Icons.add_task),
                label: const Text('Add Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
