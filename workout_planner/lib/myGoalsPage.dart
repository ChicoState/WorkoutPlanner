import 'package:flutter/material.dart';
import 'main.dart';

// page to add, track, and edit goals
class MyGoalsPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
          title: Text("My Goals")
      ),

      body: Text("Goals Page"),

      floatingActionButton: FloatingActionButton(
          onPressed:() {},
          child: Icon(Icons.add)
      ),

    );
  }
}