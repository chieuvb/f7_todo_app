import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'task_item.dart';

class DataControl {
  Future<File> getTaskFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/task-list.json');
  }

  Future<List<TaskItem>> readTasks() async {
    List<TaskItem> tasks = [];
    try {
      final file = await getTaskFile();
      if (await file.exists()) {
        String jsonString = await file.readAsString();
        if (jsonString.isNotEmpty) {
          List<dynamic> json = jsonDecode(jsonString);
          tasks = json.map((task) => TaskItem.fromJson(task)).toList();
        }
      } else {
        await file.create(recursive: true);
        debugPrint('create file ok');
      }
      debugPrint('readTask ok');
    } catch (ex) {
      debugPrint('Read error: $ex');
    }
    return tasks;
  }

  Future<void> writeTasks(List<TaskItem> tasks) async {
    try {
      final file = await getTaskFile();
      final jsonString = jsonEncode(tasks);
      await file.writeAsString(jsonString);
      debugPrint('writeTask ok');
    } catch (ex) {
      debugPrint('Write error: $ex');
    }
  }
}
