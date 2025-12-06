import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../providers/attendance_provider.dart';

class AttendancePage extends StatefulWidget {
  final String courseId;
  const AttendancePage({super.key, required this.courseId});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String today = DateTime.now().toString().split(" ")[0];

  @override
  void initState() {
    super.initState();

    final sp = Provider.of<StudentProvider>(context, listen: false);
    final ap = Provider.of<AttendanceProvider>(context, listen: false);

    sp.fetchStudents(widget.courseId);
    ap.loadAttendance(widget.courseId, today);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance ($today)")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          Provider.of<AttendanceProvider>(context, listen: false)
              .saveAttendance(widget.courseId, today);
        },
      ),
      body: Consumer2<StudentProvider, AttendanceProvider>(
        builder: (context, sp, ap, _) {
          return ListView.builder(
            itemCount: sp.students.length,
            itemBuilder: (_, i) {
              final student = sp.students[i];
              final id = student['studentId'];

              return ListTile(
                title: Text(student['studentName']),
                trailing: ToggleButtons(
                  isSelected: [
                    ap.attendanceStatus[id] == "Present",
                    ap.attendanceStatus[id] == "Absent"
                  ],
                  onPressed: (index) {
                    ap.mark(id, index == 0 ? "Present" : "Absent");
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("P"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("A"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
