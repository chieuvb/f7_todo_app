import 'package:flutter/material.dart';

class Modal extends StatefulWidget {
  const Modal({
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

  @override
  ModalState createState() => ModalState();
}

class ModalState extends State<Modal> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _actionTask(String id, BuildContext context) {
    if (widget.action == 'add') {
      widget.actionTask(controller.text);
    } else {
      widget.actionTask(id, controller.text);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isAddAction = widget.action == 'add';
    controller.text = widget.content;

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
                controller: controller,
                decoration: InputDecoration(
                  labelText: isAddAction ? 'New task' : 'Edit task',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                return SizedBox(
                  width: 80,
                  height: 54,
                  child: FilledButton(
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(width: 1, color: Colors.white),
                    ),
                    onPressed: value.text.isEmpty
                        ? null
                        : () => _actionTask(widget.id, context),
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
