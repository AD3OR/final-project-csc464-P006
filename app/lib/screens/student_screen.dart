import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';

// Color Palette
const Color c1 = Color(0xFF696D7D);
const Color c2 = Color(0xFF6F9283);
const Color c3 = Color(0xFF8D9F87);
const Color c4 = Color(0xFFCDC6A5);
const Color c5 = Color(0xFFF0DCCA);

class StudentScreen extends StatefulWidget {
  final String courseId;
  const StudentScreen({super.key, required this.courseId});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  @override
  void initState() {
    super.initState();

    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentProvider>(context, listen: false)
          .fetchStudents(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c4,
      appBar: AppBar(
        backgroundColor: c2,
        title: const Text("Students", style: TextStyle(color: c5)),
        iconTheme: const IconThemeData(color: c5),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: c2,
        onPressed: _showAddStudentDialog,
        child: const Icon(Icons.add, color: c5),
      ),

      body: Consumer<StudentProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: c2),
            );
          }

          if (provider.students.isEmpty) {
            return const Center(child: Text("No students found."));
          }

          return ListView.builder(
            itemCount: provider.students.length,
            itemBuilder: (context, i) {
              final student = provider.students[i];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Card(
                  color: c3,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      student['studentName'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: c1,
                      ),
                    ),
                    subtitle: Text(
                      "ID: ${student['studentId']}",
                      style: const TextStyle(color: c1),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: c1),
                          onPressed: () =>
                              _showEditStudentDialog(student),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: c1),
                          onPressed: () {
                            provider.deleteStudent(
                              widget.courseId,
                              student['studentId'],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ───────────────── Dialogs ─────────────────

  void _showAddStudentDialog() {
    final nameController = TextEditingController();
    final idController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: c4,
        title: const Text("Add Student", style: TextStyle(color: c1)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: _inputDecoration("Name"),
              cursorColor: c2,
            ),
            TextField(
              controller: idController,
              decoration: _inputDecoration("Student ID"),
              keyboardType: TextInputType.number,
              cursorColor: c2,
            ),
          ],
        ),
        actions: _dialogActions(
          onSave: () {
            Provider.of<StudentProvider>(context, listen: false)
                .addStudent(
              widget.courseId,
              nameController.text,
              idController.text,
            );
          },
        ),
      ),
    );
  }

  void _showEditStudentDialog(Map<String, dynamic> student) {
    final controller =
        TextEditingController(text: student['studentName']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: c4,
        title: const Text("Edit Student", style: TextStyle(color: c1)),
        content: TextField(
          controller: controller,
          decoration: _inputDecoration("Name"),
          cursorColor: c2,
        ),
        actions: _dialogActions(
          onSave: () {
            Provider.of<StudentProvider>(context, listen: false)
                .editStudent(
              widget.courseId,
              student['studentId'],
              controller.text,
            );
          },
        ),
      ),
    );
  }

  // ─────────────── Helpers ───────────────

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: c1),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: c2),
      ),
    );
  }

  List<Widget> _dialogActions({required VoidCallback onSave}) {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("Cancel", style: TextStyle(color: c1)),
      ),
      TextButton(
        onPressed: () {
          onSave();
          Navigator.pop(context);
        },
        child: const Text("Save", style: TextStyle(color: c2)),
      ),
    ];
  }
}
