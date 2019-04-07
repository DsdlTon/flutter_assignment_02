import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/model/database.dart';

class CompletePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CompletePageState();
  }
}

class CompletePageState extends State<CompletePage> {
  List<Node> items = new List();
  NodeDatabase db = new NodeDatabase();

  @override
  void initState() {
    super.initState();
    db.getAllComplete().then((notes) {
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
            title: Text('Todo'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteNode(context);
                  }),
            ],
          ),
          body: Center(
            child: Text(
              "No data found..",
              textAlign: TextAlign.center,
            ),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Todo'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteNode(context),
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
                    value: i['done'] == 0 ? false : true,
                    onChanged: (bool value) {
                      setState(() {
                        db.updateNode(Node.fromMap({
                          'id': i['id'],
                          'title': i['title'],
                          'done': false,
                        }));
                        db.getAllComplete().then((todos) {
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

  void _deleteNode(BuildContext context) async {
    db.deleteAllDone();
    db.getAllComplete().then((notes) {
      setState(() {
        items.clear();
        notes.forEach((note) {
          items.add(Node.fromMap(note));
        });
      });
    });
  }

  // ListView callTaskList() {
  //   TextStyle titleStyle = Theme.of(context).textTheme.subhead;

  //   return ListView.builder(
  //       itemCount: items.length,
  //       itemBuilder: (BuildContext context, int position) {
  //         Map i = items[position].toMap();
  //         return Card(
  //           color: Colors.white,
  //           elevation: 2.0,
  //           child: ListTile(
  //             title: Text(i['title'], style: titleStyle),
  //             trailing: Checkbox(
  //               value: i['finish'] == 0 ? false : true,
  //               onChanged: (bool value) {
  //                 setState(() {
  //                   db.updateNode(Node.fromMap(
  //                       {
  //                         'id': i['id'],
  //                         'title': i['title'],
  //                         'finish': false,
  //                       }));
  //                   db.getAllComplete().then((notes) {
  //                     setState(() {
  //                       items.clear();
  //                       notes.forEach((note) {
  //                         items.add(Node.fromMap(note));
  //                       });
  //                     });
  //                   });
  //                 });
  //               },
  //             ),
  //           ),
  //         );
  //       });
  // }
}
