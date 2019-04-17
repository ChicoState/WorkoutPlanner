import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart';
import 'goalClass.dart';

class MyGoalsPage extends StatefulWidget
{
  @override
  _MyGoalsPage createState() => _MyGoalsPage();
}

final mainReference = FirebaseDatabase.instance.reference();

// page to add, track, and edit goals
class _MyGoalsPage extends State<MyGoalsPage>
{
  final goalController = new TextEditingController();
  final descController = new TextEditingController();

  _addGoalDialog()
  {
    showDialog(
      context: context,
      child: SimpleDialog(
        title: Text("Enter a goal"),
        titlePadding: EdgeInsets.all(10.0),
        contentPadding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0)
          )
        ),
        children: <Widget>[
          new Column(
            children: <Widget>[
              new TextField(
                controller: goalController,
                decoration: new InputDecoration(
                  labelText: "Goal",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: new EdgeInsets.all(5.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )
                ),
              ),
              new SizedBox(
                height: 10,
              ),
              new TextField(
                controller: descController,
                decoration: new InputDecoration(
                  labelText: "Description",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: new EdgeInsets.all(5.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget> [
                  new RaisedButton(
                    onPressed: () => _enterButton(),
                    child: new Text(
                      'Enter',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.blue,
                  ),
                  new RaisedButton(
                    onPressed: () {
                      goalController.clear(); // makes sure there isn't leftover text from the last input
                      descController.clear();
                      Navigator.pop(context);
                    },
                    child: new Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.blue,
                  )
                ]
              ),
            ],
          ),
        ]
      ),
    );
  }

  _enterButton()
  {
    if(goalController.text == '')
    {
      showDialog(
        context: context,
        child:SimpleDialog(
          title: Text(
            "Error",
            style: TextStyle(
              fontWeight: FontWeight.bold
            )
          ),
          titlePadding: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          children: <Widget>[
            new Column(
              children: <Widget>[
                Text(
                  "Please enter a title.",
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic
                    )
                )
              ],
            )
          ],
        )
      );
      return null;
    }
    else
    {
      _commitGoal();
      print(goalController.text);
      print(descController.text);
      goalController.clear(); // makes sure there isn't leftover text from the last input
      descController.clear();
      Navigator.pop(context); // closes dialog when enter button is pressed
    }
  }

  _commitGoal()
  {
    Goal newGoal = new Goal();

    newGoal.setProperties(goalController.text, descController.text, 0);

    mainReference.push().set(newGoal.toJson());




//    newGoal.goalName = goalController.text;
//    newGoal.goalDescription = descController.text;
//    newGoal.goalCompleted = 0;
//    print("${newGoal.goalName} , ${newGoal.goalDescription} , ${newGoal.goalCompleted} ");



//    goalTitle = goalController.text;
//    goalDesc = descController.text;
//    if(goalTitle != '')
//    {
//      goals.add(goalTitle);
//      goalDescriptions.add(goalDesc);
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      body: DefaultTabController(
          length: 2,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed:() => _addGoalDialog(),
              child: Icon(Icons.add),
            ),
            appBar: AppBar(
              bottom: TabBar(tabs: [
                Tab(text: "Active"),
                Tab(text: "Completed")
              ]),
              title: Text("My Goals"),
            ),
            body: TabBarView(children: [
//              new Container (
//                child: ListView.builder(
//                  itemBuilder: (context, index) => () _buildActiveRow(index),
//                  itemCount: goals.length,
//                )
//              ),
//              new Container(
//                child: ListView.builder(
//                  itemBuilder: (context, index) => _buildCompRow(index),
//                  itemCount: goalCompleted.length,
//                )
//              )
            ])
          )
      )
    );
  }
//  final goalController = new TextEditingController();
//  final descController = new TextEditingController();

//  var goalTitle = '';
//  var goalDesc = '';
//  var goalIndex = -1;
//  List<String> goals = [];
//  List<String> goalDescriptions = [];
//  List<String> goalCompleted = [];
//  List<String> goalDescCompleted = [];
//  var goalCompIndex = 0;
//
//  _commitGoal()
//  {
//    goalTitle = goalController.text;
//    goalDesc = descController.text;
//    if(goalTitle != '')
//    {
//      goals.add(goalTitle);
//      goalDescriptions.add(goalDesc);
//    }
//  }
//
//  _commitGoalUpdate(int index)
//  {
//    goalTitle = goalController.text;
//    goalDesc = descController.text;
//    if(goalTitle != '')
//    {
//      goals[index] = goalTitle;
//      goalDescriptions[index] = goalDesc;
//    }
//  }
//
//  _enterButton()
//  {
//    if(goalController.text == '')
//    {
//      showDialog(
//        context: context,
//        child:SimpleDialog(
//          title: Text(
//            "Error",
//            style: TextStyle(
//              fontWeight: FontWeight.bold
//            )
//          ),
//          titlePadding: EdgeInsets.all(10.0),
//          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
//          children: <Widget>[
//            new Column(
//              children: <Widget>[
//                Text(
//                  "Please enter a title.",
//                    style: TextStyle(
//                      fontSize: 20,
//                      fontStyle: FontStyle.italic
//                    )
//                )
//              ],
//            )
//          ],
//        )
//      );
//      return null;
//    }
//    else
//    {
//      _commitGoal();
//      print(goalController.text);
//      print(descController.text);
//      goalController.clear(); // makes sure there isn't leftover text from the last input
//      descController.clear();
//      Navigator.pop(context); // closes dialog when enter button is pressed
//    }
//  }
//
//  _enterButtonUpdate(int index)
//  {
//    if(goalController.text == '')
//    {
//      showDialog(
//          context: context,
//          child:SimpleDialog(
//            title: Text(
//                "Error",
//                style: TextStyle(
//                    fontWeight: FontWeight.bold
//                )
//            ),
//            titlePadding: EdgeInsets.all(10.0),
//            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
//            children: <Widget>[
//              new Column(
//                children: <Widget>[
//                  Text(
//                      "Please enter a title.",
//                      style: TextStyle(
//                          fontSize: 20,
//                          fontStyle: FontStyle.italic
//                      )
//                  )
//                ],
//              )
//            ],
//          )
//      );
//      return null;
//    }
//    else
//    {
//      _commitGoalUpdate(index);
//      print(goalController.text);
//      print(descController.text);
//      goalController.clear(); // makes sure there isn't leftover text from the last input
//      descController.clear();
//      Navigator.pop(context); // closes dialog when enter button is pressed
//    }
//  }
//
//  _buildActiveRow(int index)
//  {
//    return new GestureDetector(
//      onTap: ()
//      {
//        goalIndex = index;
//        _updateGoalDialog(goalIndex);
//      },
//      child: Card(
//        color: Colors.blue[100],
//        elevation: 3,
//        margin: EdgeInsets.all(4),
//        child: Container(
//          padding: EdgeInsets.only(left: 10.0, top: 10.0),
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Expanded(
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.stretch,
//                  children: <Widget>[
//                    Text(
//                        goals[index],
//                        textAlign: TextAlign.left,
//                        style: TextStyle(
//                            fontSize: 30.0,
//                            fontWeight: FontWeight.bold
//                        )
//                    ),
//                    Text(
//                        goalDescriptions[index],
//                        style: TextStyle(
//                          fontSize: 20.0,
//                          fontStyle: FontStyle.italic,
//                        )
//                    ),
//                  ],
//                ),
//              ),
//              IconButton(
//                  icon: Icon(Icons.check),
//                  onPressed: () => _moveGoal(index)
//              )
//            ],
//          )
//        )
//      )
//    );
//  }
//  _buildCompRow(int index)
//  {
//    return new GestureDetector(
//        onTap: ()
//        {
//          goalIndex = index;
//          _updateGoalDialog(goalIndex);
//        },
//        child: Card(
//          color: Colors.blue[100],
//          elevation: 3,
//          margin: EdgeInsets.all(4),
//          child: Container(
//            padding: EdgeInsets.only(left: 10.0, top: 10.0),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Expanded(
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.stretch,
//                    children: <Widget>[
//                      Text(
//                        goalCompleted[index],
//                        textAlign: TextAlign.left,
//                        style: TextStyle(
//                            fontSize: 30.0,
//                            fontWeight: FontWeight.bold
//                        )
//                      ),
//                      Text(
//                        goalDescCompleted[index],
//                        style: TextStyle(
//                          fontSize: 20.0,
//                          fontStyle: FontStyle.italic,
//                        )
//                      ),
//                    ],
//                  ),
//                ),
//                IconButton(
//                    icon: Icon(Icons.delete),
//                    onPressed: () => _deleteGoal(index)
//                )
//              ],
//            )
//          )
//        )
//
//    );
//  }
//
//  _addGoalDialog()
//  {
//    showDialog(
//      context: context,
//      child: SimpleDialog(
//        title: Text("Enter a goal"),
//        titlePadding: EdgeInsets.all(10.0),
//        contentPadding: EdgeInsets.all(10.0),
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.all(
//            Radius.circular(5.0)
//          )
//        ),
//        children: <Widget>[
//          new Column(
//            children: <Widget>[
//              new TextField(
//                controller: goalController,
//                decoration: new InputDecoration(
//                  labelText: "Goal",
//                  filled: true,
//                  fillColor: Colors.white,
//                  contentPadding: new EdgeInsets.all(5.0),
//                  focusedBorder: OutlineInputBorder(
//                    borderRadius: BorderRadius.circular(5.0),
//                  )
//                ),
//              ),
//              new SizedBox(
//                height: 10,
//              ),
//              new TextField(
//                controller: descController,
//                decoration: new InputDecoration(
//                  labelText: "Description",
//                  filled: true,
//                  fillColor: Colors.white,
//                  contentPadding: new EdgeInsets.all(5.0),
//                  focusedBorder: OutlineInputBorder(
//                    borderRadius: BorderRadius.circular(5.0),
//                  )
//                ),
//              ),
//              new Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget> [
//                  new RaisedButton(
//                    onPressed: () => _enterButton(),
//                    child: new Text(
//                      'Enter',
//                      style: TextStyle(
//                        color: Colors.white,
//                      ),
//                    ),
//                    color: Colors.blue,
//                  ),
//                  new RaisedButton(
//                    onPressed: () {
//                      goalController.clear(); // makes sure there isn't leftover text from the last input
//                      descController.clear();
//                      Navigator.pop(context);
//                    },
//                    child: new Text(
//                      'Cancel',
//                      style: TextStyle(
//                        color: Colors.white,
//                      ),
//                    ),
//                    color: Colors.blue,
//                  )
//                ]
//              ),
//            ],
//          ),
//        ]
//      ),
//    );
//  }
//
//  _updateGoalDialog(int index)
//  {
//    showDialog(
//      context: context,
//      child: SimpleDialog(
//          title: Text("Update your goal"),
//          titlePadding: EdgeInsets.all(10.0),
//          contentPadding: EdgeInsets.all(10.0),
//          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
//          children: <Widget>[
//            new Column(
//              children: <Widget>[
//                new TextField(
//                  controller: goalController,
//                  decoration: new InputDecoration(
//                      hintText: goalTitle,
//                      filled: false,
//                      fillColor: Colors.grey[100],
//                      contentPadding: new EdgeInsets.all(5.0)
//                  ),
//                ),
//                new TextField(
//                  controller: descController,
//                  decoration: new InputDecoration(
//                      hintText: goalDesc,
//                      filled: false,
//                      fillColor: Colors.grey[100],
//                      contentPadding: new EdgeInsets.all(5.0)
//                  ),
//                ),
//                new Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget> [
//                      new RaisedButton(
//                        onPressed: () => _enterButtonUpdate(index),
//                        child: new Text('Enter'),
//                        color: Colors.blue[100],
//                      ),
//                      new RaisedButton(
//                        onPressed: () {
//                          goalController.clear(); // makes sure there isn't leftover text from the last input
//                          descController.clear();
//                          Navigator.pop(context);
//                        },
//                        child: new Text('Cancel'),
//                        color: Colors.blue[100],
//                      )
//                    ]
//                ),
//              ],
//            ),
//          ]
//      ),
//    );
//  }
//
//  _moveGoal(int index)
//  {
//    setState(() {
//      goalTitle = goals.removeAt(index);
//      goalCompleted.add(goalTitle);
//      goalDesc = goalDescriptions.removeAt(index);
//      goalDescCompleted.add(goalDesc);
//      goalCompIndex++;
////      print(goals);
////      print(goalDescriptions);
//      print(goalCompleted);
//      print(goalDescCompleted);
//    });
//  }
//
//  _deleteGoal(int index)
//  {
//    setState(() {
//      goalCompleted.removeAt(index);
//      goalDescCompleted.removeAt(index);
//      goalCompIndex--;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      drawer: NavDrawer(),
//      body: DefaultTabController(
//          length: 2,
//          child: Scaffold(
//            floatingActionButton: FloatingActionButton(
//              onPressed:() => _addGoalDialog(),
//              child: Icon(Icons.add),
//            ),
//            appBar: AppBar(
//              bottom: TabBar(tabs: [
//                Tab(text: "Active"),
//                Tab(text: "Completed")
//              ]),
//              title: Text("My Goals"),
//            ),
//            body: TabBarView(children: [
//              new Container (
//                child: ListView.builder(
//                  itemBuilder: (context, index) => _buildActiveRow(index),
//                  itemCount: goals.length,
//                )
//              ),
//              new Container(
//                child: ListView.builder(
//                  itemBuilder: (context, index) => _buildCompRow(index),
//                  itemCount: goalCompleted.length,
//                )
//              )
//            ])
//          )
//      )
//    );
//  }
}

