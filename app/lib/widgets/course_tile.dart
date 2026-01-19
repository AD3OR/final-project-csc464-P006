// lib/widgets/course_tile.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/add_edit_course_screen.dart';
import '../screens/course_routine_screen.dart';
import '../theme/colors.dart';

class CourseTile extends StatelessWidget {
  final Course course;
  const CourseTile({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CourseProvider>(context, listen: false);

    return Card(
      color: c4,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)),
          );
        },
        title: Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold, color: c1)),
        subtitle: Text(course.code, style: TextStyle(color: c1.withOpacity(0.8))),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: c2,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddEditCourseScreen(editingCourse: course)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.redAccent,
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Delete course'),
                    content: Text('Delete "${course.name}"?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                    ],
                  ),
                );
                if (confirmed == true) {
                  try {
                    await provider.deleteCourse(course.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Course deleted')));
                    }
                  } catch (e) {
                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
