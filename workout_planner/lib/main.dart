import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget
{
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

      drawer: NavDrawer()
    );
  }
}

class NavDrawer extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text("Actions\n <ADD LOGIN TEXT AND PROFILE PICTURE HERE>"),
            decoration: BoxDecoration(
              color: Colors.blue
            ),
          ),

          ListTile(
            title: Text("My Goals"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => new MyGoalsPage()));
            },
          ),

            ListTile(
              title: Text("My Fitness"),
              onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
              builder: (context) => new MyFitnessPage()));
            },
          )
        ],
      )
    );
  }
}

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