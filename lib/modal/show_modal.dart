import 'package:flutter/material.dart';

class Modal extends StatelessWidget {
  Modal(
      {super.key,
      required this.id,
      required this.action,
      required this.actionTask});

  final String id;
  final String action;
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
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: action == 'Add' ? 'New task' : 'Edit task',
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
