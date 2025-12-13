<<<<<<< Updated upstream
=======
import 'package:app/providers/routine_provider.dart';
>>>>>>> Stashed changes
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Azwad/login.dart';

import 'firebase_options.dart';

// Providers
import 'providers/student_provider.dart';
import 'providers/attendance_provider.dart';

// Screens
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Attendance App',
        home: const FacultyLoginPage(),
      ),
    );
  }
}
