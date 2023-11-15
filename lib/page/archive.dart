import 'package:flutter/material.dart';

import '../data_control.dart';
import '../modal/navbar.dart';
import '../modal/task_body.dart';
import '../task_item.dart';
import 'home.dart';

DataControl dat = DataControl();
List<TaskItem> tasks = [];

class ArchivedTasks extends StatefulWidget {
  const ArchivedTasks({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<ArchivedTasks> {
  @override
  void initState() {
    super.initState();
    loadTask();
  }

  void loadTask() async {
    try {
      List<TaskItem> tasksList = await dat.readTasks();
      setState(() {
        tasks = tasksList;
      });
      debugPrint('load tasks ok ${tasks.length}');
    } catch (e) {
      debugPrint('Failed to load tasks: $e');
    }
  }

  void writeTasks() {
    try {
      dat.writeTasks(tasks);
    } catch (e) {
      debugPrint('Failed to write tasks: $e');
    }
  }

  void deleteTask(String id) {
    setState(() {
      try {
        TaskItem? item = tasks.firstWhere((item) => item.id == id,
            orElse: () => TaskItem(id: '0', content: '0', status: 'completed'));
        item.status = item.status.replaceAll('_archived', '');
        if (!item.status.contains('deleted')) {
          item.status += '_deleted';
        }
        writeTasks();
        debugPrint('deleted task ${tasks.length}');
      } catch (e) {
        debugPrint('Failed to delete task: $e');
      }
    });
  }

  void unArchive(String id) {
    setState(() {
      try {
        TaskItem? item = tasks.firstWhere((item) => item.id == id,
            orElse: () =>
                TaskItem(id: '0', content: '', status: 'uncompleted'));
        if (item.status.contains('archived')) {
          item.status = item.status.replaceAll('_archived', '');
        }
        writeTasks();
        debugPrint('unarchived task: $item ${tasks.length}');
      } catch (ex) {
        debugPrint('Failed to unarchive task: $ex');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Archived',
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.amber,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
            size: 32,
          ),
        ),
      ),
      drawer: NavBar(list: tasks),
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
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  for (TaskItem item in tasks)
                    if (item.status.contains('archived'))
                      NewTask(
                        item,
                        index: tasks.indexOf(item),
                        action: 'a',
                        editTask: () {},
                        updateTask: () => debugPrint(''),
                        delTask: deleteTask,
                        arcTask: () {},
                        unArc: unArchive,
                        unDel: () {},
                      ),
                  NewTask(
                    TaskItem(id: '0', content: '', status: 'uncompleted'),
                    editTask: () {},
                    action: '',
                    updateTask: () {},
                    delTask: () {},
                    arcTask: () {},
                    index: 0,
                    unArc: () {},
                    unDel: () {},
                  ),
                ],
              ),
            ),
    );
  }
}
