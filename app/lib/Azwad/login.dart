// flutter_login_page.dart
// Login page for Attendance app (Faculty)
// - Uses Firebase Authentication (email/password)
// - On success, navigates to Home() from home.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import your existing home screen (you uploaded home.dart). Make sure
// the Home widget is exported from that file as `Home`.
import "package:app/home.dart";

class FacultyLoginPage extends StatefulWidget {
  const FacultyLoginPage({Key? key}) : super(key: key);

  @override
  State<FacultyLoginPage> createState() => _FacultyLoginPageState();
}

class _FacultyLoginPageState extends State<FacultyLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  // Initialize Firebase if not already initialized.
  // In your main.dart you should call `WidgetsFlutterBinding.ensureInitialized();`
  // and `await Firebase.initializeApp();` before running the app. This check here
  // protects against double initialization if you use this page in isolation.
  Future<void> _ensureFirebaseInitialized() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
    } catch (e) {
      // ignore errors here; main should handle initialization.
    }
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      print('[LOGIN] Starting sign-in process');
      await _ensureFirebaseInitialized();
      print('[LOGIN] Firebase initialized successfully');

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      print(
        '[LOGIN] FirebaseAuth signIn successful for: \${_emailController.text.trim()}',
      );

      if (credential.user != null) {
        print('[LOGIN] Navigating to Home()');
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      print('[ERROR] FirebaseAuthException: \${e.code} - \${e.message}');
      String message = 'Authentication failed';

      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        message = 'Email address is not valid.';
      } else {
        message = 'Firebase auth error: \${e.message}';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      print('[ERROR] Unexpected login error: \$e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unexpected error occurred. Check console logs.'),
        ),
      );
    } finally {
      print('[LOGIN] Sign-in process finished');
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Faculty Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo / Title
                const SizedBox(height: 12),
                const FlutterLogo(size: 72),
                const SizedBox(height: 16),
                const Text(
                  'Attendance — Faculty Login',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Please enter email';
                    if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(v))
                      return 'Enter valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter password';
                    if (v.length < 6)
                      return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Login button or loading indicator
                SizedBox(
                  width: double.infinity,
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _signIn,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.0),
                            child: Text(
                              'Log in',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 12),

                // Optional: Forgot password / Register links
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // TODO: implement password reset flow
                      },
                      child: const Text('Forgot password?'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Optional: open registration screen (if you support creating faculty accounts)
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
  How to use:
  1) Add firebase_core and firebase_auth to your pubspec.yaml:
     firebase_core: ^2.10.0
     firebase_auth: ^4.6.0
     (Check pub.dev for latest versions)

  2) Configure Firebase project (Android: google-services.json, iOS: GoogleService-Info.plist)
     Follow Firebase docs to register your app and download the config files.

  3) In your main.dart (before runApp) initialize Firebase:
     void main() async {
       WidgetsFlutterBinding.ensureInitialized();
       await Firebase.initializeApp();
       runApp(const MyApp());
     }

  4) Replace your login route to push to FacultyLoginPage, and ensure Home() exists in home.dart.

  5) If you don't want to use Firebase, you can implement a REST/JWT backend instead and authenticate
     by calling your API (then securely store the JWT using secure_storage). For production-ready apps
     Firebase is often the fastest, secure choice for MVPs and many teams.
*/
