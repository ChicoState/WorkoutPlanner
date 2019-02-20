import 'package:flutter/material.dart';
import 'main.dart';

// page to add and update personal weight
class MyPersonalInfoPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
          title: Text("Personal Information")
      ),

      body: Text("Personal Information Page"),

      floatingActionButton: FloatingActionButton(
          onPressed:() {},
          child: Icon(Icons.add)
      ),

    );
  }
}