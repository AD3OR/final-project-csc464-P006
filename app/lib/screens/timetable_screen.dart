import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../models/routine.dart';
import '../providers/course_provider.dart';
import '../providers/routine_provider.dart';
import '../theme/colors.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  static const List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutineProvider>(context, listen: false);
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: c5,
      appBar: AppBar(
        backgroundColor: c2,
        title: const Text(
          "Weekly Timetable",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<List<Routine>>(
        stream: routineProvider.routinesStream,
        builder: (context, routineSnapshot) {
          if (!routineSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final routines = routineSnapshot.data!;

          return StreamBuilder<List<Course>>(
            stream: courseProvider.coursesStream,
            builder: (context, courseSnapshot) {
              if (!courseSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final courses = courseSnapshot.data!;
              final courseMap = {
                for (var c in courses) c.id: c,
              };

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  final dayRoutines =
                      routines.where((r) => r.day == day).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: c1,
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (dayRoutines.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 16),
                          child: Text(
                            "No classes",
                            style: TextStyle(color: c1.withOpacity(0.6)),
                          ),
                        ),

                      ...dayRoutines.map((routine) {
                        final course = courseMap[routine.courseId];
                        if (course == null) return const SizedBox();

                        return _routineCard(course, routine);
                      }).toList(),

                      const SizedBox(height: 24),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _routineCard(Course course, Routine routine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c4,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            course.code,
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
          const SizedBox(height: 6),
          Text(
            "${routine.startTime} - ${routine.endTime}",
            style: TextStyle(color: Colors.black.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}
