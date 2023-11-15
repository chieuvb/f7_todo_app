import 'package:flutter/material.dart';

import '../data_control.dart';
import '../modal/navbar.dart';
import '../modal/show_modal.dart';
import '../modal/task_body.dart';
import '../task_item.dart';

DataControl dat = DataControl();
List<TaskItem> tasks = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<HomePage> {
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
      debugPrint('add tasks ok ${tasks.length}');
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

  void addTask(String name) {
    TaskItem item = TaskItem(
      id: DateTime.now().toString(),
      content: name,
      status: 'uncompleted',
    );
    setState(() {
      tasks.add(item);
      writeTasks();
    });
  }

  void editTask(String id, String newContent) {
    int ind = tasks.indexWhere((item) => item.id == id);
    setState(() {
      tasks[ind].content = newContent;
      writeTasks();
    });
  }

  void updateTask(String id) {
    int ind = tasks.indexWhere((item) => item.id == id);
    setState(() {
      if (tasks[ind].status == 'completed') {
        tasks[ind].status = 'uncompleted';
      } else {
        tasks[ind].status = 'completed';
      }
      writeTasks();
    });
  }

  void archiveTask(String id) {
    setState(() {
      try {
        TaskItem? item = tasks.firstWhere((item) => item.id == id,
            orElse: () =>
                TaskItem(id: '0', content: '0', status: 'uncompleted'));
        if (!item.status.contains('archived')) {
          item.status += '_archived';
        }
        writeTasks();
        debugPrint('archived task ${tasks.length}');
      } catch (ex) {
        debugPrint('Failed to archive task: $ex');
      }
    });
  }

  void deleteTask(String id) {
    setState(() {
      try {
        TaskItem? item = tasks.firstWhere((item) => item.id == id,
            orElse: () => TaskItem(id: '0', content: '0', status: 'completed'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.amber,
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
                  const Text('In progress tasks'),
                  for (TaskItem item in tasks)
                    if (item.status == 'uncompleted')
                      NewTask(
                        item,
                        index: tasks.indexOf(item),
                        editTask: editTask,
                        updateTask: updateTask,
                        delTask: deleteTask,
                        arcTask: archiveTask,
                        action: '',
                        unArc: () {},
                        unDel: () {},
                      ),
                  NewTask(
                    TaskItem(id: '0', content: '', status: 'uncompleted'),
                    editTask: () {},
                    updateTask: () {},
                    delTask: () {},
                    arcTask: () {},
                    index: 0,
                    action: '',
                    unArc: () {},
                    unDel: () {},
                  ),
                  const Text('Completed tasks'),
                  for (TaskItem item in tasks)
                    if (item.status == 'completed')
                      NewTask(
                        item,
                        index: tasks.indexOf(item),
                        editTask: editTask,
                        updateTask: updateTask,
                        delTask: deleteTask,
                        arcTask: archiveTask,
                        action: '',
                        unArc: () {},
                        unDel: () {},
                      ),
                  NewTask(
                    TaskItem(id: '0', content: '', status: 'uncompleted'),
                    editTask: () {},
                    updateTask: () {},
                    delTask: () {},
                    arcTask: () {},
                    index: 0,
                    action: '',
                    unArc: () {},
                    unDel: () {},
                  ),
                ],
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
            Radius.circular(30),
          ),
        ),
        backgroundColor: Colors.amber,
        tooltip: 'Add task',
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }
}
