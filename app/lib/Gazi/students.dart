import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';

class StudentsPage extends StatefulWidget {
  final String courseId;
  const StudentsPage({super.key, required this.courseId});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<StudentProvider>(context, listen: false)
        .fetchStudents(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Students")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddStudentDialog(),
        child: Icon(Icons.add),
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, _) {
          return ListView.builder(
            itemCount: provider.students.length,
            itemBuilder: (context, i) {
              final student = provider.students[i];
              return ListTile(
                title: Text(student['studentName']),
                subtitle: Text("ID: ${student['studentId']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => showEditStudentDialog(student),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        provider.deleteStudent(widget.courseId, student['studentId']);
                      },
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

  void showAddStudentDialog() {
    final nameController = TextEditingController();
    final idController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Student"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: idController, decoration: InputDecoration(labelText: "Student ID")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<StudentProvider>(context, listen: false).addStudent(
                widget.courseId,
                nameController.text,
                idController.text,
              );
              Navigator.pop(context);
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }

  void showEditStudentDialog(Map<String, dynamic> student) {
    final controller = TextEditingController(text: student['studentName']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Student"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<StudentProvider>(context, listen: false)
                  .editStudent(widget.courseId, student['studentId'], controller.text);
              Navigator.pop(context);
            },
            child: Text("Update"),
          )
        ],
      ),
    );
  }
}
