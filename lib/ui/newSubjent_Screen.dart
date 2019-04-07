import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/model/database.dart';

class NewNodePage extends StatefulWidget {
  final Node todo;
  NewNodePage(this.todo);

  @override
  State<StatefulWidget> createState() {
    return NewNodePageState();
  }
}

class NewNodePageState extends State<NewNodePage> {
  NodeDatabase db = NodeDatabase();

  final _itemAdd = GlobalKey<FormState>();
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.todo.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Subject')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _itemAdd,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: "Subject",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill subject";
                  }
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      child: Text("save"),
                      onPressed: () {
                        if (_itemAdd.currentState.validate()) {
                          db
                              .createNewNode(Node.getValue(_textController.text))
                              .then((_) {
                            Navigator.pop(context);
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
