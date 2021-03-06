import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrumproject/models/todo.dart';
import 'package:scrumproject/screens/add_todo.dart';
import 'package:scrumproject/screens/login_screen.dart';
import 'package:scrumproject/service/auth_service.dart';
import 'package:scrumproject/service/todo_service.dart';
import 'edit_todo.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  int backPressCounter = 0;
  int selectedExpansionTile = -1;

  @override
  void initState() {
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Tickets List"),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.login,
                  color: Colors.redAccent,
                  size: 30,
                ),
                onPressed: () {
                  AuthService.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                      settings: RouteSettings(name: '/login'),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
              )
            ],
          ),
          body: getTodoListBody(context),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.blue,
            label: Text("Add Ticket"),
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTodo(),
                  settings: RouteSettings(name: '/add_todo'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget getTodoListBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: TodoService().getTodoListOfCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        Widget child;    
        if (snapshot.hasError) {
          child = Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          child = Center(
            child: Text(
              "Loading",
              style: TextStyle(color: Colors.blueGrey),
            ),
          );
        } else if (snapshot.data.size == 0) {
          child = Center(
            child: Text("All TASKs are caught up"),
          );
        } else if (snapshot.hasData && snapshot.data.size > 0) {
          child = Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                Todo todo = Todo.fromJson(snapshot.data.docs[index].data());
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  actions: [
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTodo(todo),
                          ),
                        )
                      },
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => {TodoService().deleteByID(todo.uuid)},
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Card(
                      color: Colors.white70,
                      child: ExpansionTile(
                        initiallyExpanded: index == selectedExpansionTile,
                        onExpansionChanged: ((newState) {
                          if (newState)
                            setState(() {
                              selectedExpansionTile = index;
                            });
                          else
                            setState(() {
                              selectedExpansionTile = -1;
                            });
                        }),
                        leading: Icon(Icons.fiber_smart_record_rounded),
                        title: Text(
                          todo.todoTitle,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                        children: todo.taskList
                            .asMap()
                            .entries
                            .map(
                              (task) => CheckboxListTile(
                                contentPadding: EdgeInsets.only(left: 30),
                                value: task.value.status,
                                title: Text(task.value.taskDescription),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      task.value.status = value;
                                      TodoService()
                                          .updateByID(todo.toJson(), todo.uuid);
                                    },
                                  );
                                },
                              ),
                            )
                            .toList(),
                        trailing: Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return child;
      },
    );
  }

  Future<bool> onWillPop() {
    if (backPressCounter < 1) {
      backPressCounter++;
      Fluttertoast.showToast(msg: "Press again to exit !!!");
      Future.delayed(Duration(seconds: 2, milliseconds: 0), () {
        backPressCounter--;
      });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
