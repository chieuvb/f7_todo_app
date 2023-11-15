import 'package:f7_todo_app/page/archive.dart';
import 'package:f7_todo_app/page/delete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../page/home.dart';
import '../task_item.dart';

class NavBar extends StatelessWidget {
  final List<TaskItem> list;

  const NavBar({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Van Chieu'),
            accountEmail: const Text('chieuvanbui22@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/image/chieuvb.jpg'),
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.circle_outlined,
            ),
            title: const Text('In progress'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.archive_rounded,
            ),
            title: const Text('Archived'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ArchivedTasks()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_rounded,
            ),
            title: const Text('Deleted'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DeletedTasks()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.settings_rounded,
            ),
            title: const Text('Settings'),
            onTap: () {
              null;
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app_rounded,
            ),
            title: const Text('Exit'),
            onTap: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }
}
