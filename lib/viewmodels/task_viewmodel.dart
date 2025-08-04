import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_management/models/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'tasks';

  Stream<List<TaskModel>> getTasks() {
    return _firestore
        .collection(_collectionPath)
        .where('isArchived', isEqualTo: false)
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Stream<List<TaskModel>> getArchivedTasks() {
    return _firestore
        .collection(_collectionPath)
        .where('isArchived', isEqualTo: true)
        .orderBy('dueDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Future<void> addTask(TaskModel task) async {
    await _firestore.collection(_collectionPath).add(task.toMap());
  }

  Future<void> archiveTask(String taskId) async {
    await _firestore.collection(_collectionPath).doc(taskId).update({
      'isArchived': true,
    });
  }

  Future<void> markCompleted(String taskId, bool value) async {
    await _firestore.collection(_collectionPath).doc(taskId).update({
      'isCompleted': value,
    });
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final doc = await _firestore.collection(_collectionPath).doc(taskId).get();
    final current = doc.data()?['isCompleted'] ?? false;
    await doc.reference.update({'isCompleted': !current});
  }

  Future<void> updateTask(String taskId, TaskModel updatedTask) async {
    await _firestore
        .collection(_collectionPath)
        .doc(taskId)
        .update(updatedTask.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection(_collectionPath).doc(taskId).delete();
  }
}
