import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/materials_repository.dart';
import 'main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudentEduApp());
}

class StudentEduApp extends StatelessWidget {
  const StudentEduApp({super.key, this.materialsRepository});

  final MaterialsRepository? materialsRepository;

  @override
  Widget build(BuildContext context) {
    final baseText = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return MaterialApp(
      title: 'Student Resources',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF050814),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4B7BFF),
          brightness: Brightness.dark,
          surface: const Color(0xFF0D1224),
        ),
        textTheme: baseText,
      ),
      home: MainShell(materialsRepository: materialsRepository),
    );
  }
}
