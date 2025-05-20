import 'package:cftracker_app/app/pages/root/root_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CFTrackerApp());
}

class CFTrackerApp extends StatelessWidget {
  const CFTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CFTracker',
      theme: ThemeData(
        primaryColor: const Color(0xFF0070C0),
        useMaterial3: true,
      ),
      home: const RootPage(),
    );
  }
}
