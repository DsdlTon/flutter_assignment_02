import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/model/database.dart';
import 'package:flutter_assignment_02/ui/newSubjent_Screen.dart';

class TaskPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskPageState();
  }
}

class TaskPageState extends State<TaskPage> {
  List<Node> items = List();
  NodeDatabase db = new NodeDatabase();

  int count = 0;

  @override
  void initState() {
    super.initState();

    db.getAllNode().then((notes) {
      setState(() {
        notes.forEach((note) {
          items.add(Node.fromMap(note));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (items.length == 0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Todo"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _toNewSubject(context);
              },
            )
          ],
        ),
        body: Center(
          child: Text(
            "No data found..",
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Todo'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _toNewSubject(context),
            ),
          ],
        ),
        body: Center(
          child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
              itemCount: items.length,
              itemBuilder: (context, position) {
                Map i = items[position].toMap();
                return ListTile(
                  title: Text(i['title'],
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 1.5)),
                  trailing: Checkbox(
                    value: i['done'] == 1 ? false : true,
                    onChanged: (bool value) {
                      setState(() {
                        db.updateNode(Node.fromMap({
                          'id': i['id'], // old id
                          'title': i['title'], // old title
                          'done': true, // change data as TRUE
                        }));
                        db.getAllNode().then((todos) {
                          // restart read Data when it changed
                          setState(() {
                            items.clear();
                            todos.forEach((note) {
                              items.add(Node.fromMap(note));
                            });
                          });
                        });
                      });
                    },
                  ),
                );
              }),
        ),
      );
    }
  }

  void _toNewSubject(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewNodePage(Node.getValue(''))),
    );

    db.getAllNode().then((todos) {
      // restart read Data when it changed
      setState(() {
        items.clear();
        todos.forEach((note) {
          items.add(Node.fromMap(note));
        });
      });
    });
  }
}
