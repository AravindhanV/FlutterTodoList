import 'package:flutter/material.dart';

import 'addtask.dart';
import 'listview.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 15),
          // child: FloatingActionButton(
          //   child: Icon(Icons.edit),
          //   elevation: 35,
          //   onPressed: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => AddTask())).then((x) {
          //       print("Refreshing");
          //       setState(() {
          //           print("Setting");
          //       });
          //       print("Set the State");
          //     });
          //   },
          // ),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  "All Tasks",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Kau',
                    fontSize: 35,
                  ),
                ),
              ),
              Expanded(
                child: TodoList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
