import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'modal/show_modal.dart';
import 'modal/task_body.dart';
import 'modal/task_item.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'To do',
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

List<TaskItem> items = [];

Future<List<TaskItem>> readTasks() async {
  final String jsonString = await rootBundle.loadString('assets/data.json');
  final List<dynamic> json = jsonDecode(jsonString);
  return json.map((item) => TaskItem.fromJson(item)).toList();
}

void writeTask(TaskItem tasks) async {
  final jsonString = jsonEncode(tasks);
  await File('assets/data.json').writeAsString(jsonString);
}

Future<void> appLoad() async {
  items = await readTasks();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    appLoad();
  }

  void _addTask(String name) {
    TaskItem item = TaskItem(
      id: DateTime.now().toString(),
      content: name,
      complete: false,
    );
    setState(() {
      items.add(item);

      writeTask(item);
    });
  }

  void _completed(String id) {
    int ind = items.indexWhere((item) => item.id == id);
    bool comp = items[ind].complete;

    setState(() {
      items[ind].complete = comp ? false : true;
    });
  }

  void _deleteTask(String id) {
    setState(() {
      items.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'To do',
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: items
              .map((item) => NewTask(
                    item,
                    index: items.indexOf(item),
                    completed: _completed,
                    delTask: _deleteTask,
                  ))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.amber[100],
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            builder: (BuildContext context) {
              return ShowModal(
                addTask: _addTask,
              );
            },
          );
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        backgroundColor: Colors.amber,
        tooltip: 'Add task',
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
