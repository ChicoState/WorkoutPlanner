import 'package:flutter/material.dart';
import 'main.dart';

// page to add and update personal weight
class MyFitnessPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
          title: Text("My Fitness")
      ),

      body: Text("Fitness Page"),

      floatingActionButton: FloatingActionButton(
          onPressed:() {},
          child: Icon(Icons.add)
      ),

    );
  }
}