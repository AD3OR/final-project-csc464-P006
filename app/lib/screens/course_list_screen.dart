// lib/screens/course_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../models/course.dart';
import '../widgets/course_tile.dart';
import 'add_edit_course_screen.dart';
import '../theme/colors.dart';

class CourseListScreen extends StatelessWidget {
  static const routeName = '/courses';
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CourseProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: c5,
      appBar: AppBar(
        backgroundColor: c2,
        title: const Text('Courses', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<List<Course>>(
        stream: provider.coursesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final courses = snapshot.data ?? [];
          if (courses.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.book, size: 64, color: c1),
                    SizedBox(height: 12),
                    Text('No courses yet', style: TextStyle(fontSize: 18, color: c1)),
                    SizedBox(height: 8),
                    Text('Tap the + button to add your first course', textAlign: TextAlign.center, style: TextStyle(color: c1)),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12.0),
            itemCount: courses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final course = courses[index];
              return CourseTile(course: course);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: c3,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditCourseScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

