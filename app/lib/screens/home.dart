import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../providers/student_provider.dart';
import '../providers/attendance_provider.dart';
import '../providers/course_provider.dart';
import '../providers/routine_provider.dart';

// Existing screens
import '../models/students.dart';
import '../models/att.dart';

// Course & routine screens
import 'course_list_screen.dart';
import 'course_select_routine_screen.dart';
import 'timetable_screen.dart';

// Custom Color Palette
const Color c1 = Color(0xFF696D7D);
const Color c2 = Color(0xFF6F9283);
const Color c3 = Color(0xFF8D9F87);
const Color c4 = Color(0xFFCDC6A5);
const Color c5 = Color(0xFFF0DCCA);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c5,
      appBar: AppBar(
        backgroundColor: c2,
        title: const Text(
          "Teacher Dashboard",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Manage Students
            _menuButton(
              context,
              title: "Manage Students",
              icon: Icons.group,
              color: c1,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudentsPage(courseId: "COURSE_001"),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Take Attendance
            _menuButton(
              context,
              title: "Take Attendance",
              icon: Icons.check_circle,
              color: c3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AttendancePage(courseId: "COURSE_001"),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Manage Courses (ONLY course add/edit/delete)
            _menuButton(
              context,
              title: "Manage Courses",
              icon: Icons.book,
              color: c4,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CourseListScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Manage Routine (select course -> routines)
            _menuButton(
              context,
              title: "Manage Routine",
              icon: Icons.schedule,
              color: c2,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CourseSelectRoutineScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Weekly Timetable
            _menuButton(
              context,
              title: "View Timetable",
              icon: Icons.calendar_month,
              color: c3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TimetableScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// App root with providers
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => RoutineProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Attendance App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: c2),
          useMaterial3: false,
        ),
        home: const HomePage(),
      ),
    );
  }
}
