import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget
{
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: "Workout Planner",
      home: HomePage()
    );
  }
}

class HomePage extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout Planner")
      ),

      drawer: Drawer(
        child: Text("\n\n\nDrawer")
      )
    );
  }
}
