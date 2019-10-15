import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'addtask.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Task> list = [];

  Future<Database> database;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDatabase().then((x) {
      getTasks();
    });
    print("Database = $database");

    print(list);
  }

  Future<List<Task>> getTasks() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('tasks');

    list = List.generate(maps.length, (i) {
      return Task(
          id: maps[i]['id'],
          title: maps[i]['title'],
          description: maps[i]['description'],
          date: maps[i]['date']);
    });
    print("List now: $list");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        list.length != 0
            ? ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  String des = list[index].description;
                  if (des.length > 20) {
                    des = des.substring(0, 20);
                    des = des + "...";
                  }
                  return Dismissible(
                    onDismissed: (x) async {
                      Database db = await database;
                      print(list[index].id);
                      db.rawDelete(
                          "delete from tasks where id=${list[index].id}");
                      setState(() {
                        list.removeAt(index);
                      });
                    },
                    key: ValueKey(list[index].title),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: ListTile(
                        title: Text(
                          list[index].title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(Icons.image),
                        trailing: Text(list[index].date),
                        subtitle: Text(des),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  "No Tasks To Show",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
        Positioned(
          height: 70,
          width: 70,
          bottom: 30,
          right: 26,
          child: FloatingActionButton(
            onPressed: () {
              print("Pressed");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddTask())).then((x) {
                print("Refreshing");
                setState(() {
                  getTasks();
                });
                print("Set the State");
              });
            },
            child: Icon(Icons.edit),
            tooltip: "Add Task",
          ),
        ),
      ],
    );
  }

  Future<void> initDatabase() async {
    database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'todo_list.db'),
      onConfigure: (db) {
        print("Configured");
      },
      onOpen: (db) {
        print("Opened");
        // db.execute(
        //   "CREATE TABLE IF NOT EXISTS tasks (title VARCHAR(20), description VARCHAR(50), date DATE)",
        // );
      },
      onCreate: (db, version) {
        print("Creating");
        return db.execute(
          "CREATE TABLE IF NOT EXISTS tasks (id integer primary key autoincrement, title VARCHAR(20), description VARCHAR(50), date VARCHAR(10))",
        );
      },
      version: 1,
    );
    print("DBINIT: $database");
  }
}

class Task {
  String title;
  String description;
  String date;
  int id;
  Task({this.title, this.description, this.date, this.id = -23});

  Map<String, dynamic> toMap() {
    return {'title': title, 'description': description, 'date': date};
  }
}
