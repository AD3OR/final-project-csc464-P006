import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../models/course.dart';
import '../theme/colors.dart';

class AddEditCourseScreen extends StatefulWidget {
  final Course? editingCourse;
  const AddEditCourseScreen({super.key, this.editingCourse});

  @override
  State<AddEditCourseScreen> createState() => _AddEditCourseScreenState();
}

class _AddEditCourseScreenState extends State<AddEditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.editingCourse != null) {
      _nameCtrl.text = widget.editingCourse!.name;
      _codeCtrl.text = widget.editingCourse!.code;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final provider = Provider.of<CourseProvider>(context, listen: false);

    try {
      if (widget.editingCourse == null) {
        await provider.addCourse(
          _nameCtrl.text.trim(),
          _codeCtrl.text.trim(),
        );
      } else {
        await provider.updateCourse(
          widget.editingCourse!.id,
          _nameCtrl.text.trim(),
          _codeCtrl.text.trim(),
        );
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration field(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: c4.withOpacity(0.25),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.editingCourse != null;

    return Scaffold(
      backgroundColor: c5,
      appBar: AppBar(
        backgroundColor: c2,
        title: Text(editing ? "Edit Course" : "Add Course",
            style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: field("Course name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _codeCtrl,
                decoration: field("Course code"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 24),
              _saving
                  ? const CircularProgressIndicator(color: c2)
                  : SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _save,
                        child: Text(editing ? "Save Changes" : "Create Course"),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
