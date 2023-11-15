import 'package:f7_todo_app/page/home.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      title: 'To do',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
