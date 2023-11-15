import 'package:f7_todo_app/modal/show_modal.dart';
import 'package:f7_todo_app/task_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NewTask extends StatelessWidget {
  final TaskItem item;
  final int index;
  final String action;
  final Function editTask;
  final Function updateTask;
  final Function arcTask;
  final Function delTask;
  final Function unArc;
  final Function unDel;

  const NewTask(
    this.item, {
    super.key,
    required this.index,
    required this.action,
    required this.editTask,
    required this.updateTask,
    required this.arcTask,
    required this.delTask,
    required this.unArc,
    required this.unDel,
  });

  Future<void> updateT() async {
    if (action != 'd' && action != 'a') {
      updateTask(item.id);
    } else {
      debugPrint('you can\'t do it here');
    }
  }

  Future<void> deleteT(BuildContext context) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: action == 'd'
                ? const Text('Permanently delete this task?')
                : const Text('Delete this task?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Accept'),
                onPressed: () {
                  Navigator.of(context).pop();
                  delTask(item.id);
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint('error: $e');
    }
  }

  Future<void> archiveT(BuildContext context) async {
    try {
      arcTask(item.id);
    } catch (e) {
      debugPrint('error: $e');
    }
  }

  void doAction(BuildContext context) {
    try {
      if (action != 'a' && action != 'd') {
        return;
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: action == 'a'
                ? const Text('Restore archived task?')
                : const Text('Restore deleted task?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Accept'),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (action == 'a') {
                    unArc(item.id);
                  } else if (action == 'd') {
                    unDel(item.id);
                  }
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCompleted = item.status == 'completed';
    return item.id != '0'
        ? SizedBox(
            height: 80,
            child: Slidable(
              key: Key(item.id),
              startActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(30),
                    ),
                    onPressed: action == 'a'
                        ? doAction
                        : action != 'd'
                            ? archiveT
                            : doAction,
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                    icon: action == 'a'
                        ? Icons.unarchive_rounded
                        : action != 'd'
                            ? Icons.archive_rounded
                            : Icons.restore_from_trash_rounded,
                    label: action == 'a'
                        ? 'Unarchive'
                        : action != 'd'
                            ? 'Archive'
                            : 'Restore',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(30),
                    ),
                    onPressed: deleteT,
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    icon: action != 'd'
                        ? Icons.delete_rounded
                        : Icons.delete_forever_rounded,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: item.status != 'uncompleted'
                      ? Colors.black38
                      : index % 2 == 0
                          ? const Color.fromARGB(100, 255, 64, 64)
                          : const Color.fromARGB(100, 32, 32, 255),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: IconButton(
                        onPressed: updateT,
                        icon: Icon(
                          item.status == 'completed'
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.content,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          decoration:
                              isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: IconButton(
                        onPressed: () {
                          if (action != 'd') {
                            showModalBottomSheet(
                              backgroundColor: Colors.amber[100],
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return Modal(
                                  id: item.id,
                                  action: 'edit',
                                  content: item.content,
                                  actionTask: editTask,
                                );
                              },
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.border_color_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox(
            height: 64,
            child: Center(
              child: Text(item.content),
            ),
          );
  }
}
