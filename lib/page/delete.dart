import 'package:flutter/material.dart';

import '../data_control.dart';
import '../modal/navbar.dart';
import '../modal/task_body.dart';
import '../task_item.dart';
import 'home.dart';

DataControl dat = DataControl();
List<TaskItem> tasks = [];

class DeletedTasks extends StatefulWidget {
  const DeletedTasks({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<DeletedTasks> {
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
        tasks.removeWhere((item) => item.id == id);
        writeTasks();
        debugPrint('permanently deleted task ${tasks.length}');
      } catch (e) {
        debugPrint('Failed to delete task: $e');
      }
    });
  }

  void unDelete(String id) {
    setState(() {
      try {
        TaskItem? item = tasks.firstWhere((item) => item.id == id,
            orElse: () =>
                TaskItem(id: '0', content: '', status: 'uncompleted'));
        if (item.status.contains('deleted')) {
          item.status = item.status.replaceAll('_deleted', '');
        }
        writeTasks();
        debugPrint('undelete task successfully task: $item ${tasks.length}');
      } catch (e) {
        debugPrint('Failed to delete task: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Deleted',
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
                    if (item.status.contains('deleted'))
                      NewTask(
                        item,
                        index: tasks.indexOf(item),
                        action: 'd',
                        editTask: () {},
                        updateTask: () {},
                        delTask: deleteTask,
                        arcTask: () {},
                        unArc: () {},
                        unDel: unDelete,
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
