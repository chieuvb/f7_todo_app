import 'package:flutter/material.dart';

class Modal extends StatelessWidget {
  Modal({
    super.key,
    required this.id,
    required this.action,
    required this.content,
    required this.actionTask,
  });

  final String id;
  final String action;
  final String content;
  final Function actionTask;

  final TextEditingController controller = TextEditingController();

  void _actionTask(String id, BuildContext context) {
    if (controller.text.isEmpty) {
      return;
    }
    if (action == 'add') {
      actionTask(controller.text);
    } else {
      actionTask(id, controller.text);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    controller.text = content;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: TextField(
                maxLines: null,
                autofocus: true,
                autocorrect: true,
                controller: controller,
                decoration: InputDecoration(
                  labelText: action == 'add' ? 'New task' : 'Edit task',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            ElevatedButton(
              onPressed: () => _actionTask(id, context),
              child: Text(action),
            ),
          ],
        ),
      ),
    );
  }
}
