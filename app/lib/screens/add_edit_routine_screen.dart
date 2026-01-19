import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/routine.dart';
import '../providers/routine_provider.dart';
import '../theme/colors.dart';

class AddEditRoutineScreen extends StatefulWidget {
  final Routine? editingRoutine;
  final String courseId;

  const AddEditRoutineScreen({
    super.key,
    this.editingRoutine,
    required this.courseId,
  });

  @override
  State<AddEditRoutineScreen> createState() => _AddEditRoutineScreenState();
}

class _AddEditRoutineScreenState extends State<AddEditRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();

  String _day = "Monday";
  bool _saving = false;

  final List<String> _days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.editingRoutine != null) {
      final r = widget.editingRoutine!;
      _day = r.day;
      _startCtrl.text = r.startTime;
      _endCtrl.text = r.endTime;
    }
  }

  @override
  void dispose() {
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final provider = Provider.of<RoutineProvider>(context, listen: false);

    try {
      if (widget.editingRoutine == null) {
        await provider.addRoutine(
          courseId: widget.courseId,
          day: _day,
          startTime: _startCtrl.text.trim(),
          endTime: _endCtrl.text.trim(),
        );
      } else {
        await provider.updateRoutine(
          id: widget.editingRoutine!.id,
          day: _day,
          startTime: _startCtrl.text.trim(),
          endTime: _endCtrl.text.trim(),
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
    final editing = widget.editingRoutine != null;

    return Scaffold(
      backgroundColor: c5,
      appBar: AppBar(
        backgroundColor: c2,
        title: Text(
          editing ? "Edit Routine" : "Add Routine",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                initialValue: _day,
                decoration: field("Day"),
                items: _days
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => _day = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _startCtrl,
                decoration: field("Start time (e.g. 09:00)"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _endCtrl,
                decoration: field("End time (e.g. 10:30)"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 24),
              _saving
                  ? const CircularProgressIndicator(color: c2)
                  : SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c2,
                        ),
                        onPressed: _save,
                        child:
                            Text(editing ? "Save Changes" : "Create Routine"),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
