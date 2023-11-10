import 'package:f7_todo_app/show_modal.dart';
import 'package:f7_todo_app/task_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NewTask extends StatelessWidget {
  final TaskItem item;
  final int index;
  final Function editTask;
  final Function updateTask;
  final Function delTask;

  const NewTask(
    this.item, {
    super.key,
    required this.editTask,
    required this.updateTask,
    required this.delTask,
    required this.index,
  });

  Future<bool> confirm(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xác nhận'),
            content: const Text('Bạn có chắc muốn xóa công việc này không?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Hủy'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('Xóa'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        updateTask(item.id);
      },
      onLongPress: () async {
        if (await confirm(context)) {
          delTask(item.id);
        }
      },
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: item.status
              ? Colors.black38
              : (index % 2 == 0 ? Colors.lightBlue : Colors.green),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: InkWell(
                child: Icon(
                  item.status
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
                style: item.status
                    ? const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        decoration: TextDecoration.lineThrough,
                      )
                    : const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16),
              child: InkWell(
                onTap: () {
                  if (kDebugMode) {
                    print('editPress ${item.id}');
                  }
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
                },
                child: const Icon(
                  Icons.border_color_rounded,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
