import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentProvider with ChangeNotifier {
  final _db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> students = [];

  final bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Fetch students of a course
  Future<void> fetchStudents(String courseId) async {
    final snap = await _db
        .collection('students')
        .doc(courseId)
        .collection('students')
        .get();

    students = snap.docs.map((e) => e.data()).toList();
    notifyListeners();
  }

  // Add student
  Future<void> addStudent(
    String courseId,
    String name,
    String studentId,
  ) async {
    await _db
        .collection('students')
        .doc(courseId)
        .collection('students')
        .doc(studentId)
        .set({'studentName': name, 'studentId': studentId});

    students.add({'studentName': name, 'studentId': studentId});
    notifyListeners();
  }

  // Edit student
  Future<void> editStudent(
    String courseId,
    String studentId,
    String newName,
  ) async {
    await _db
        .collection('students')
        .doc(courseId)
        .collection('students')
        .doc(studentId)
        .update({'studentName': newName});

    final index = students.indexWhere((s) => s['studentId'] == studentId);
    students[index]['studentName'] = newName;
    notifyListeners();
  }

  // Delete student
  Future<void> deleteStudent(String courseId, String studentId) async {
    await _db
        .collection('students')
        .doc(courseId)
        .collection('students')
        .doc(studentId)
        .delete();

    students.removeWhere((s) => s['studentId'] == studentId);
    notifyListeners();
  }
}
