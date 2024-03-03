import 'package:flutter/material.dart';
import 'package:taskly_app/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main(List<String> args) async {
  await Hive.initFlutter("Hive_Boxes");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taskly',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 230, 18, 18),
      ),
      home: const HomePage(),
    );
  }
}
