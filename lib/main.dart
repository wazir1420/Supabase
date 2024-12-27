import 'package:chatsupa/models/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9taHdraXZ6dG5za3FqdnlzZ3FoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUwNzI3ODcsImV4cCI6MjA1MDY0ODc4N30.C5FdXkLRkoITAvNwQNCXe_dlE8W30K5VwBnF1Ui1_n4",
      url: "https://omhwkivztnskqjvysgqh.supabase.co");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
