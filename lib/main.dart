import 'dart:math';
import 'package:flutter/material.dart';
import 'models/question.dart';
import 'generators/question_generator.dart';
import 'screens/home_screen.dart';
import 'screens/preview_screen.dart';

void main() {
  runApp(const MathPaperApp());
}

class MathPaperApp extends StatelessWidget {
  const MathPaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '小学数学试卷',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Microsoft YaHei',
      ),
      home: const HomeScreen(),
      routes: {
        '/preview': (context) => const PreviewScreen(),
      },
    );
  }
}
