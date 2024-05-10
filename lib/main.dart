import 'package:courseanalysis/features/auth/sign_in.dart';
import 'package:courseanalysis/features/enrolled_department/departments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(color: Colors.red),
        ),
      ),
    ),
  );

  final lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      themeMode: ThemeMode.light,
      darkTheme: darkTheme,
      theme: lightTheme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return EnrolledDepartments();
          } else {
            return const SignIn();
          }
        },
      ),
    );
  }
}
