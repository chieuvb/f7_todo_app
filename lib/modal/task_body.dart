import 'package:f7_todo_app/modal/show_modal.dart';
import 'package:f7_todo_app/modal/task_item.dart';
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
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: item.status ? Colors.black54 : Colors.lightBlue,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.content,
              style: item.status
                  ? const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.lineThrough,
                    )
                  : const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
            ),
            InkWell(
              onTap: () {
                if (kDebugMode) {
                  print('onLongPress ${item.id}');
                }
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
                      id: item.id,
                      action: 'edit',
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
          ],
        ),
      ),
    );
  }
}
