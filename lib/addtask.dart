import 'package:flutter/material.dart';
import 'package:flutterworkshop/listview.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String datestr = "Choose a Date";
  Future<Database> database;
  final _title = TextEditingController();
  final _description = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initdb();
  }

  initdb() async {
    database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'todo_list.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE IF NOT EXISTS tasks (id integer primary key autoincrement, title VARCHAR(20), description VARCHAR(50), date VARCHAR(10))",
        );
      },
      version: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Color(0xFF047B8C),
            Color(0xFF4138B2),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 30),
                  child: Text(
                    "Add New Task",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Kau',
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        CustomTextField("Title", 1,_title),
                        CustomTextField("Description", 5,_description),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, left: 12),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Due Date : ",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _chooseDate(context),
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Icon(
                                          Icons.calendar_today,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: Text(
                                          datestr,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.yellow[600],
                    onPressed: () {
                      insertTask(context);
                    },
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text("Add Task"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> insertTask(BuildContext context) async{
    String title = _title.text;
    String description = _description.text;
    print(datestr);
    Task t = Task(title: title,description: description,date: datestr);

    final Database db = await database;
    await db.rawInsert("insert into tasks (title,description,date) values ('${t.title}','${t.description}','${t.date}')");
    // await db.insert('tasks',t.toMap());
    print("Popping");
    Navigator.pop(context);
    print("Popped");
  }

  _chooseDate(BuildContext context) async {
    DateTime chosen = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2020),
    );
    if (chosen == null) {
      return;
    }
    var date = chosen.day;
    if (date < 10) {
      datestr = "0${date}";
    } else {
      datestr = "$date";
    }
    datestr = datestr + "-";
    var month = chosen.month;
    if (month < 10) {
      datestr = datestr + "0$month";
    } else {
      datestr = datestr + "$month";
    }
    datestr = datestr + "-";
    var year = chosen.year;
    datestr = datestr + "$year";
    setState(() {});
  }

  Widget CustomTextField(String s, int lines,TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          color: Colors.white,
        ),
        cursorColor: Colors.white,
        maxLines: lines,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.white),
          labelText: s,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
