import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'main.dart';

class ExercisesPage extends StatefulWidget
{
  @override
  _ExercisesPage createState() => _ExercisesPage();
}

class _ExercisesPage extends State<ExercisesPage>
{
  


  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text("Explore Exercises")
        ),





      )
    );
  }
}

