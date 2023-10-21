import 'package:flutter/material.dart';

class ShowModal extends StatelessWidget {
  ShowModal({super.key, required this.addTask});

  final TextEditingController controller = TextEditingController();
  final Function addTask;

  void _addNewTask(BuildContext context) {
    if (controller.text.isEmpty) {
      return;
    }
    addTask(controller.text);
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
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'New task',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            ElevatedButton(
              onPressed: () => _addNewTask(context),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
