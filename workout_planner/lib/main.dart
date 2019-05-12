import 'package:flutter/material.dart';
import 'myGoalsPage.dart';
import 'myPersonalInfoPage.dart';
import 'exercisesPage.dart';
import 'workoutPlanPage.dart';
import 'auth.dart';
import 'root.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: "Workout Planner",
      //theme: ThemeData.dark(),
      home: RootPage(auth: Auth())
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

class NavDrawer extends StatefulWidget{

  @override
  NavDrawerState createState() => NavDrawerState();
}

class NavDrawerState extends State<NavDrawer>
{

//  BaseAuth auth;
//  String userID = "";
//  String userEmail = "";
//
//  void initState() {
//    super.initState();
//    auth.getCurrentUser().then((user) {
//      setState(() {
//        userID = user.uid;
//      });
//      userEmail = user.email;
//
//      if (userID == "")
//        print("ERROR: USERID IS NULL");
//    });
//  }

  @override
  Widget build(BuildContext context)
  {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.lightBlue,
                  radius: 50,
                  child: Text("FIX")
                    //TODO add user's first letter of email
//                  child: userID == "" ? Text("") : Text(
//                    "${userEmail[0].toUpperCase()}",
//                    style: TextStyle(fontSize: 40))
                )

                //TODO add user's email below circle avatar

              ],
            ),


            decoration: BoxDecoration(
              color: Colors.blue
            ),
          ),

          ListTile(
            title: Text("My Goals"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => new MyGoalsPage(auth: Auth())));
            },
          ),

          ListTile(
            title: Text("Personal Information"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
              builder: (context) => new RootPage(auth: Auth())));
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
                  builder: (context) => new WorkoutPlanPage(auth: Auth())));
            },
          ),

//          ListTile(
//            title: Text("Login"),
//            onTap: () {
//              Navigator.pop(context);
//              Navigator.push(context, MaterialPageRoute(
//                  builder: (context) => new RootPage(auth: Auth())));
//            },
//          )
        ],
      )
    );
  }
}
