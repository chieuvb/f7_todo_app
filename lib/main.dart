import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'data_control.dart';
import 'show_modal.dart';
import 'task_body.dart';
import 'task_item.dart';

DataControl dat = DataControl();
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
    List<TaskItem> tasksList = await dat.readTasks();
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
      dat.writeTasks(tasks);
      if (kDebugMode) {
        print('addTask ok');
      }
    });
  }

  void editTask(String id, String newContent) {
    int ind = tasks.indexWhere((item) => item.id == id);
    setState(() {
      tasks[ind].content = newContent;
      dat.writeTasks(tasks);
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
      dat.writeTasks(tasks);
      if (kDebugMode) {
        print('updateTask ok ${tasks[ind].status}');
      }
    });
  }

  void deleteTask(String id) {
    setState(() {
      tasks.removeWhere((item) => item.id == id);
      dat.writeTasks(tasks);
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
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks',
                style: TextStyle(fontSize: 24),
              ),
            )
          : SingleChildScrollView(
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
                content: '',
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
