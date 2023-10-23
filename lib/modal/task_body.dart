import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:f7_todo_app/modal/task_item.dart';
import 'package:flutter/material.dart';

class NewTask extends StatelessWidget {
  final TaskItem item;
  final int index;
  final Function completed;
  final Function delTask;

  const NewTask(this.item,
      {super.key,
      required this.delTask,
      required this.index,
      required this.completed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        completed(item.id);
      },
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: item.complete ? Colors.blueGrey : Colors.lightBlue,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.content,
              style: item.complete
                  ? const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.lineThrough,
                    )
                  : const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
            ),
            InkWell(
              onTap: () async {
                if (await confirm(context)) {
                  delTask(item.id);
                }
              },
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
