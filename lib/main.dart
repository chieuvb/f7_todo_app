import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'logic/interact.dart';
import 'modal/show_modal.dart';
import 'modal/task_body.dart';
import 'modal/task_item.dart';

Interact inter = Interact();
List<TaskItem> tasks = [];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      title: 'To do',
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
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
    loadTask();
  }

  void loadTask() async {
    List<TaskItem> tasksList = await inter.readTasks();
    setState(() {
      tasks = tasksList;
    });
    if (kDebugMode) {
      print('loadTask ok');
    }
  }

  void addTask(String name) {
    TaskItem item = TaskItem(
      id: DateTime.now().toString(),
      content: name,
      status: false,
    );
    setState(() {
      tasks.add(item);
      inter.writeTasks(tasks);
      if (kDebugMode) {
        print('addTask ok');
      }
    });
  }

  void editTask(String id, String newContent) {
    int ind = tasks.indexWhere((item) => item.id == id);
    setState(() {
      tasks[ind].content = newContent;
      inter.writeTasks(tasks);
      if (kDebugMode) {
        print('editTask ok ${tasks[ind].content}');
      }
    });
  }

  void updateTask(String id) {
    int ind = tasks.indexWhere((item) => item.id == id);
    bool comp = tasks[ind].status;
    setState(() {
      tasks[ind].status = comp ? false : true;
      inter.writeTasks(tasks);
      if (kDebugMode) {
        print('updateTask ok ${tasks[ind].status}');
      }
    });
  }

  void deleteTask(String id) {
    setState(() {
      tasks.removeWhere((item) => item.id == id);
      inter.writeTasks(tasks);
      if (kDebugMode) {
        print('deleteTask ok ${tasks.length}');
      }
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
          children: tasks
              .map((item) => NewTask(
                    item,
                    index: tasks.indexOf(item),
                    editTask: editTask,
                    updateTask: updateTask,
                    delTask: deleteTask,
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
              return Modal(
                id: 'none',
                action: 'add',
                actionTask: addTask,
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
