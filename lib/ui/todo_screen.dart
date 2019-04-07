import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/ui/complete_screen.dart';
import 'package:flutter_assignment_02/ui/task_screen.dart';



class TodoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoState();
  }
}

class TodoState extends State<TodoPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    TaskPage(),
    CompletePage(),
  ];
  void onTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTab,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Task'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            title: Text('Completed'),
          ),
        ],
      ),
    );
  }
}
