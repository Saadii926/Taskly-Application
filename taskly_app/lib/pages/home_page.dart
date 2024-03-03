import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:taskly_app/model/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late double _deviceWidth;
  late double _deviceHeight;

  Box? _box;

  String? addNewTask;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    // _deviceWidth = MediaQuery.of(context).size.width;
    // print("New Task:: $addNewTask");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: _deviceHeight * 0.11,
          title: const Text(
            'Taskly! App',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontSize: 20,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        // Body of UI
        body: _taskview(),
        floatingActionButton: _floatingbutton(),
      ),
    );
  }

// Task view
  Widget _taskview() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _box = snapshot.data;
          return _listview();
        } else {
          return const LinearProgressIndicator();
        }
      },
    );
  }

// List View and tile
  Widget _listview() {
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        var task = Task.formMap(tasks[index]);
        DateTime now = task.timestamp;
        String formatdate =
            DateFormat('h:mm:a' '    ' 'dd/MM/yyyy').format(now);
        return ListTile(
          title: Text(
            task.content,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: task.done ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(formatdate),
          trailing: Icon(
            task.done
                ? Icons.check_box
                : Icons.check_box_outline_blank_outlined,
            color: Theme.of(context).primaryColor,
          ),
          onTap: () {
            task.done = !task.done;
            _box!.putAt(index, task.toMap());
            setState(() {});
          },
          onLongPress: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Are you Sure you want to delete this task?",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        _box!.deleteAt(index);
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

// Floating action button
  Widget _floatingbutton() {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: _displayTast,
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  // Display function
  void _displayTast() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add New Task',
            style: TextStyle(fontSize: 15),
          ),
          content: TextField(
            onSubmitted: (_) {
              if (addNewTask != null) {
                var task = Task(
                    content: addNewTask!,
                    timestamp: DateTime.now(),
                    done: false);
                _box!.add(task.toMap());
              }
              setState(() {
                addNewTask = null;
                Navigator.of(context).pop();
              });
            },
            onChanged: (value) {
              setState(() {
                addNewTask = value;
              });
            },
          ),
        );
      },
    );
  }
}
