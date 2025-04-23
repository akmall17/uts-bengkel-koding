// lib/main.dart

import 'package:flutter/material.dart';

import 'todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi List Film Keren',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber, // Warna tema utama
        scaffoldBackgroundColor: Colors.white, // Background halaman
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.amber, // AppBar kuning
          foregroundColor: Colors.black, // Teks AppBar hitam
          elevation: 0, // Tanpa bayangan
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: const TodoPage(),
    );
  }
}
