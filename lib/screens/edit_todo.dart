import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrumproject/models/task.dart';
import 'package:scrumproject/models/todo.dart';
import 'package:scrumproject/service/todo_service.dart';

class EditTodo extends StatefulWidget {
  final Todo todo;

  EditTodo(this.todo);

  @override
  _EditTodoState createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  String _title;
  String _description;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Task> _taskList;

  @override
  void initState() {
    super.initState();
    _title = widget.todo.todoTitle;
    _description = widget.todo.todoDesc;
    _taskList = widget.todo.taskList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blue,
          label: Text("Add Task"),
          icon: Icon(Icons.add),
          onPressed: () {
            if (_taskList.last.taskDescription == null ||
                _taskList.last.taskDescription.isEmpty) {
              Fluttertoast.showToast(msg: "Please enter task");
            } else {
              setState(
                () {
                  _taskList.add(Task.fromJson({}));
                },
              );
            }
          },
        ),
        appBar: AppBar(
          title: Text("Edit Ticket"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.save,
                size: 30,
              ),
              color: Colors.greenAccent,
              onPressed: () => submit(context),
            ),
            IconButton(
              icon: Icon(
                Icons.cancel,
                size: 30,
              ),
              color: Colors.redAccent,
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 50, 8, 20),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _title,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: null,
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                    autofocus: false,
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          style: BorderStyle.none,
                        ),
                      ),
                      labelText: "Ticket Title",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      fillColor: Colors.white30,
                      filled: true,
                      contentPadding: EdgeInsets.all(14),
                    ),
                    validator: (title) {
                      if (title.trim().isEmpty) {
                        return "Please enter Ticket Title";
                      } else if (_title != title) {
                        _title = title;
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    initialValue: _description,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: null,
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                    autofocus: false,
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          style: BorderStyle.none,
                        ),
                      ),
                      labelText: "Ticket Description",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      fillColor: Colors.white10,
                      filled: true,
                      contentPadding: EdgeInsets.all(14),
                    ),
                    validator: (desc) {
                      if (desc.trim().isEmpty) {
                        return "Please enter Ticket Decsription";
                      } else if (_description != desc) {
                        _description = desc;
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _taskList.length == 1
                      ? TextFormField(
                          initialValue: _taskList[0].taskDescription,
                          obscureText: false,
                          textAlign: TextAlign.start,
                          maxLines: null,
                          autofocus: false,
                          cursorColor: Colors.blue,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                style: BorderStyle.none,
                              ),
                            ),
                            labelText: "Task 1",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: Colors.white10,
                            filled: true,
                            contentPadding: EdgeInsets.all(14),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _taskList[0].taskDescription = value;
                            });
                          },
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Please enter task';
                            }
                            return null;
                          },
                        )
                      : _taskList.length > 1
                          ? ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _taskList.length,
                              itemBuilder: (BuildContext context, int index) {
                                Task _task = _taskList[index];
                                return Padding(
                                  key: ObjectKey(_task),
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: TextFormField(
                                          initialValue:
                                              _taskList[index].taskDescription,
                                          obscureText: false,
                                          textAlign: TextAlign.start,
                                          maxLines: null,
                                          autofocus: false,
                                          cursorColor: Colors.blue,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            labelText: "Task ${index + 1}",
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            fillColor: Colors.white,
                                            filled: true,
                                            contentPadding: EdgeInsets.all(14),
                                          ),
                                          validator: (value) {
                                            if (value.trim().isEmpty) {
                                              return 'Please enter task';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            _taskList[index].taskDescription =
                                                value;
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () {
                                          setState(
                                            () {
                                              _taskList.removeAt(index);
                                            },
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  submit(BuildContext context) {
    if (_formKey.currentState.validate()) {
      Todo todo = new Todo();
      todo.todoTitle = _title;
      todo.todoDesc = _description;
      todo.taskList = _taskList;
      TodoService().updateByID(todo.toJson(), widget.todo.uuid);
      Navigator.pop(context);
    }
  }
}
