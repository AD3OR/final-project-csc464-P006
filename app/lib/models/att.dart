import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Color Palette
const Color c1 = Color(0xFF696D7D);
const Color c2 = Color(0xFF6F9283);
const Color c3 = Color(0xFF8D9F87);
const Color c4 = Color(0xFFCDC6A5);
const Color c5 = Color(0xFFF0DCCA);

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key, required this.courseId});
  final String courseId;

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  Map<int, bool> attendanceStatus = {}; // studentId → present/absent

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c5,
      appBar: AppBar(
        backgroundColor: c2,
        title: const Text(
          "Take Attendance",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("students").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final students =
              snapshot.data?.docs ?? []; // handle null snapshot.data

          print("Snapshot data: ${snapshot.data?.docs.map((d) => d.data())}");

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: students.length,
            itemBuilder: (context, index) {
              var doc = students[index];
              var student =
                  doc.data() as Map<String, dynamic>?; // make nullable
              if (student == null) return const SizedBox(); // skip if null

              String studentName = student['studentName'] ?? 'No Name';
              int studentId = student['id'] ?? 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: c3,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            studentName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "ID: $studentId",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Checkbox(
                      activeColor: c1,
                      value: attendanceStatus[studentId] ?? false,
                      onChanged: (value) {
                        setState(() {
                          attendanceStatus[studentId] = value!;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: c1,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            // will implement later
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Attendance recorded (mock).")),
            );
          },
          child: const Text(
            "Submit Attendance",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
