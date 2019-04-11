import 'package:flutter/material.dart';
import 'myGoalsPage.dart';
import 'myPersonalInfoPage.dart';
import 'exercisesPage.dart';
import 'workoutPlanPage.dart';

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
            title: Text("Personal Information"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
              builder: (context) => new MyPersonalInfoPage()));
            },
          ),

          ListTile(
            title: Text("Explore Exercises"),
            onTap: () {



              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => new ExercisesPage()));
            },
          ),
          ListTile(
            title: Text("Workout Plan"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => new WorkoutPlanPage()));
            },
          )
        ],
      )
    );
  }
}
