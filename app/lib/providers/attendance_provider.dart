import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceProvider with ChangeNotifier {
  final _db = FirebaseFirestore.instance;

  Map<String, String> attendanceStatus = {}; // { studentId: "Present/Absent" }

  // Load attendance for a specific date
  Future<void> loadAttendance(String courseId, String date) async {
    final doc = await _db
        .collection('attendance')
        .doc(courseId)
        .collection('dates')
        .doc(date)
        .get();

    if (doc.exists) {
      attendanceStatus = Map<String, String>.from(doc['status']);
    } else {
      attendanceStatus = {};
    }

    notifyListeners();
  }

  // Mark student present/absent locally
  void mark(String studentId, String value) {
    attendanceStatus[studentId] = value;
    notifyListeners();
  }

  // Save to Firebase
  Future<void> saveAttendance(String courseId, String date) async {
    await _db
        .collection('attendance')
        .doc(courseId)
        .collection('dates')
        .doc(date)
        .set({'status': attendanceStatus});
  }
}
