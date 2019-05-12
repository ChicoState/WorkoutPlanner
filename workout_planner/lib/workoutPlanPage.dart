import 'package:flutter/material.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'models/Workout.dart';

class WorkoutPlanPage extends StatefulWidget
{
  WorkoutPlanPage({this.auth});

  final BaseAuth auth;

  @override
  _WorkoutPlanPage createState() => _WorkoutPlanPage();
}

final Firestore firebaseDB = Firestore.instance;

class _WorkoutPlanPage extends State<WorkoutPlanPage>
{
  String userID = "";
  List<dynamic> workoutNames = List<dynamic>();
  List<dynamic> workoutSets = List<dynamic>();
  List<dynamic> workoutReps = List<dynamic>();
  List<dynamic> workoutWeights = List<dynamic>();
  var checkBox = Icon(Icons.check_box_outline_blank);

  final exerController = new TextEditingController();
  final repsController = new TextEditingController();
  final setsController = new TextEditingController();
  final weightsController = new TextEditingController();

  final exerCompController = new TextEditingController();
  final repsCompController = new TextEditingController();
  final setsCompController = new TextEditingController();

  var exerTitle = '';
  var exerReps = '';
  var exerSets = '';
  var exerIndex = -1;
  List<String> exer = [];
  List<String> exerRep = [];
  List<String> exerSet = [];
  List<String> exerCompleted = [];
  List<String> exerRepsCompleted = [];
  List<String> exerSetsCompleted = [];
  var exerCompIndex = 0;

  String hintSets = "Recommended Sets: 6-8";
  String hintReps = "Recommended Reps: 10-20";

  int _buttonValue = 2;

  String showGoal;

  void initState()
  {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        userID = user.uid;
      });
    });
  }

//  _enterButtonUpdate(int index)
//  {
//    if(exerController.text == '')
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
//      print(exerController.text);
//      print(repsController.text);
//      print(setsController.text);
//      exerController.clear(); // makes sure there isn't leftover text from the last input
//      repsController.clear();
//      setsController.clear();
//      Navigator.pop(context); // closes dialog when enter button is pressed
//    }
//  }
//
//  _enterCompButtonUpdate(int index)
//  {
//    if(exerCompController.text == '')
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
//      _commitCompGoalUpdate(index);
//      print(exerCompController.text);
//      print(repsCompController.text);
//      print(setsCompController.text);
//      exerCompController.clear(); // makes sure there isn't leftover text from the last input
//      repsCompController.clear();
//      setsCompController.clear();
//      Navigator.pop(context); // closes dialog when enter button is pressed
//    }
//  }
//
//
//  _buildActiveRow(int index)
//  {
//    return new GestureDetector(
//        onTap: ()
//        {
//          exerIndex = index;
//          _updateGoalDialog(exerIndex);
//        },
//        child: Card (
//          color: Colors.blue[100],
//          elevation : 4,
//          child : Container(
//              padding: EdgeInsets.only(left: 10.0, top: 10.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Expanded(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
//                      children: <Widget>[
//                        Text(
//                            exer[index],
//                            textAlign: TextAlign.left,
//                            style: TextStyle(
//                                fontSize: 30.0,
//                                fontWeight: FontWeight.bold
//                            )
//                        ),
//                        Text(
//                            "Reps: ${exerRep[index]} ",
//                            style: TextStyle(
//                              fontSize: 20.0,
//                              fontStyle: FontStyle.italic,
//                            )
//                        ),
//                        Text(
//                            "Sets: ${exerSet[index]}",
//                            style: TextStyle(
//                              fontSize: 20.0,
//                              fontStyle: FontStyle.italic,
//                            )
//                        ),
//                      ],
//                    ),
//                  ),
//                  IconButton(
//                      icon: Icon(Icons.check),
//                      onPressed: () => _deleteGoal(index)
//                  )
//                ],
//              )
//          )
//        )
//    );
//  }
//  _buildCompRow(int index)
//  {
//    return new GestureDetector(
//        onTap: ()
//        {
//          exerIndex = index;
//          _updateCompGoalDialog(exerIndex);
//        },
//        child: Card(
//        color: Colors.blue[100],
//        elevation: 4,
//          child: Container(
//              padding: EdgeInsets.only(left: 10.0, top: 10.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Expanded(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
//                      children: <Widget>[
//                        Text(
//                            exerCompleted[index],
//                            textAlign: TextAlign.left,
//                            style: TextStyle(
//                                fontSize: 30.0,
//                                fontWeight: FontWeight.bold
//                            )
//                        ),
//                        Text(
//                            "Reps: ${exerRepsCompleted[index]}",
//                            style: TextStyle(
//                              fontSize: 20.0,
//                              fontStyle: FontStyle.italic,
//                            )
//                        ),
//                        Text(
//                            "Sets: ${exerSetsCompleted[index]}",
//                            style: TextStyle(
//                              fontSize: 20.0,
//                              fontStyle: FontStyle.italic,
//                            )
//                        ),
//                      ],
//                    ),
//                  ),
//                  IconButton(
//                      icon: Icon(Icons.refresh),
//                      onPressed: () => _redoGoal(index)
//                  ),
//                  IconButton(
//                      icon: Icon(Icons.delete),
//                      onPressed: () => _deleteCompletedGoal(index)
//                  )
//                ],
//              )
//          )
//        )
//    );
//      if(userID == "")
//        print("ERROR: USERID IS NULL");
//    });
//  }

//  _commitGoal()
//  {
//    exerTitle = exerController.text;
//    exerReps = repsController.text;
//    exerSets = setsController.text;
//    if(exerTitle != '')
//    {
//      exer.add(exerTitle);
//      exerRep.add(exerReps);
//      exerSet.add(exerSets);
//    }
//  }
//
//  _commitGoalUpdate(int index)
//  {
//    exerTitle = exerController.text;
//    exerReps = repsController.text;
//    exerSets = setsController.text;
//    if(exerTitle != '')
//    {
//      exer[index] = exerTitle;
//      exerRep[index] = exerReps;
//      exerSet[index] = exerSets;
//    }
//  }
//
//  _commitCompGoalUpdate(int index)
//  {
//    exerTitle = exerCompController.text;
//    exerReps = repsCompController.text;
//    exerSets = setsCompController.text;
//    if(exerTitle != '')
//    {
//      exerCompleted[index] = exerTitle;
//      exerRepsCompleted[index] = exerReps;
//      exerSetsCompleted[index] = exerSets;
//    }
//  }
//
//  _enterButton()
//  {
//    if(exerController.text == '')
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
//      _commitGoal();
//      print(exerController.text);
//      print(repsController.text);
//      print(setsController.text);
//      exerController.clear(); // makes sure there isn't leftover text from the last input
//      repsController.clear();
//      setsController.clear();
//      Navigator.pop(context); // closes dialog when enter button is pressed
//    }
//  }
//
//  _enterButtonUpdate(int index)
//  {
//    if(exerController.text == '')
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
//      print(exerController.text);
//      print(repsController.text);
//      print(setsController.text);
//      exerController.clear(); // makes sure there isn't leftover text from the last input
//      repsController.clear();
//      setsController.clear();
//      Navigator.pop(context); // closes dialog when enter button is pressed
//    }
//  }
//
//  _enterCompButtonUpdate(int index)
//  {
//    if(exerCompController.text == '')
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
//      _commitCompGoalUpdate(index);
//      print(exerCompController.text);
//      print(repsCompController.text);
//      print(setsCompController.text);
//      exerCompController.clear(); // makes sure there isn't leftover text from the last input
//      repsCompController.clear();
//      setsCompController.clear();
//      Navigator.pop(context); // closes dialog when enter button is pressed
//    }
//  }
//
//
//  _buildActiveRow(int index)
//  {
//    new Card (
//        color: Colors.blue[100],
//        elevation : 4,
//        child : Container(
//            padding: EdgeInsets.only(left: 10.0, top: 10.0),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Expanded(
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.stretch,
//                    children: <Widget>[
//                      Text(
//                          showGoal,
//                          textAlign: TextAlign.left,
//                          style: TextStyle(
//                              fontSize: 30.0,
//                              fontWeight: FontWeight.bold
//                          )
//                      ),
//                    ],
//                  ),
//                ),
//                IconButton(
//                    icon: Icon(Icons.check),
//                    onPressed: () => _deleteGoal(index)
//                )
//              ],
//            )
//        )
//    );
//
//    return new GestureDetector(
//        onTap: ()
//        {
//          exerIndex = index;
//          _updateGoalDialog(exerIndex);
//        },
//        child: Card (
//          color: Colors.blue[100],
//          elevation : 4,
//          child : Container(
//              padding: EdgeInsets.only(left: 10.0, top: 10.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Expanded(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
//                      children: <Widget>[
//                        Text(
//                            exer[index],
//                            textAlign: TextAlign.left,
//                            style: TextStyle(
//                                fontSize: 30.0,
//                                fontWeight: FontWeight.bold
//                            )
//                        ),
//                        Text(
//                            "Reps: ${exerRep[index]} ",
//                            style: TextStyle(
//                              fontSize: 20.0,
//                              fontStyle: FontStyle.italic,
//                            )
//                        ),
//                        Text(
//                            "Sets: ${exerSet[index]}",
//                            style: TextStyle(
//                              fontSize: 20.0,
//                              fontStyle: FontStyle.italic,
//                            )
//                        ),
//                      ],
//                    ),
//                  ),
//                  IconButton(
//                      icon: Icon(Icons.check),
//                      onPressed: () => _deleteGoal(index)
//                  )
//                ],
//              )
//          )
//        )
//    );
//  }
//  _buildCompRow(int index)
//  {
//    return new GestureDetector(
//        onTap: ()
//        {
//          exerIndex = index;
//          _updateCompGoalDialog(exerIndex);
//        },
//        child: Card(
//        color: Colors.blue[100],
//        elevation: 4,
//          child: Container(
//              padding: EdgeInsets.only(left: 10.0, top: 10.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Expanded(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
//                      children: <Widget>[
//                        Text(
//                            exerCompleted[index],
//                            textAlign: TextAlign.left,
//                            style: TextStyle(
//                                fontSize: 30.0,
//                                fontWeight: FontWeight.bold
//                            )
//                        ),
//                        Text(
//                            "Reps: ${exerRepsCompleted[index]}",
//                            style: TextStyle(
//                              fontSize: 20.0,
//                              fontStyle: FontStyle.italic,
//                            )
//                        ),
//                        Text(
//                            "Sets: ${exerSetsCompleted[index]}",
//                            style: TextStyle(
//                              fontSize: 20.0,
//                              fontStyle: FontStyle.italic,
//                            )
//                        ),
//                      ],
//                    ),
//                  ),
//                  IconButton(
//                      icon: Icon(Icons.refresh),
//                      onPressed: () => _redoGoal(index)
//                  ),
//                  IconButton(
//                      icon: Icon(Icons.delete),
//                      onPressed: () => _deleteCompletedGoal(index)
//                  )
//                ],
//              )
//          )
//        )
//    );
//  }
//
//  _addGoalDialog()
//  {
//    showDialog(
//      context: context,
//      child: SimpleDialog(
//          title: Text("Enter an exercise"),
//          titlePadding: EdgeInsets.all(10.0),
//          contentPadding: EdgeInsets.all(10.0),
//          shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.all(
//                  Radius.circular(5.0)
//              )
//          ),
//          children: <Widget>[
//            new Column(
//              children: <Widget>[
//                new TextField(
//                  controller: exerController,
//                  decoration: new InputDecoration(
//                      labelText: "Exercise",
//                      filled: true,
//                      fillColor: Colors.white,
//                      contentPadding: new EdgeInsets.all(5.0),
//                      focusedBorder: OutlineInputBorder(
//                        borderRadius: BorderRadius.circular(5.0),
//                      )
//                  ),
//                ),
//                new SizedBox(
//                  height: 5,
//                ),
//                new TextField(
//                  controller: repsController,
//                  decoration: new InputDecoration(
//                      hintText: hintReps,
////                      labelText: hintReps,
//                      filled: true,
//                      fillColor: Colors.white,
//                      contentPadding: new EdgeInsets.all(5.0),
//                      focusedBorder: OutlineInputBorder(
//                        borderRadius: BorderRadius.circular(5.0),
//                      )
//                  ),
//                ),
//                new TextField(
//                  controller: setsController,
//                  decoration: new InputDecoration(
//                      hintText: hintSets,
////                      labelText: hintSets,
//                      filled: true,
//                      fillColor: Colors.white,
//                      contentPadding: new EdgeInsets.all(5.0),
//                      focusedBorder: OutlineInputBorder(
//                        borderRadius: BorderRadius.circular(5.0),
//                      )
//                  ),
//                ),
//                new Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget> [
//                      new RaisedButton(
//                        onPressed: () => _enterButton(),
//                        child: new Text(
//                          'Enter',
//                          style: TextStyle(
//                            color: Colors.white,
//                          ),
//                        ),
//                        color: Colors.blue,
//                      ),
//                      new RaisedButton(
//                        onPressed: () {
//                          exerController.clear(); // makes sure there isn't leftover text from the last input
//                          repsController.clear();
//                          setsController.clear();
//                          Navigator.pop(context);
//                        },
//                        child: new Text(
//                          'Cancel',
//                          style: TextStyle(
//                            color: Colors.white,
//                          ),
//                        ),
//                        color: Colors.blue,
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
//  _updateGoalDialog(int index)
//  {
//    showDialog(
//      context: context,
//      child: SimpleDialog(
//          title: Text("Update your Exercise"),
//          titlePadding: EdgeInsets.all(10.0),
//          contentPadding: EdgeInsets.all(10.0),
//          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
//          children: <Widget>[
//            new Column(
//              children: <Widget>[
//                new TextField(
//                  controller: exerController,
//                  decoration: new InputDecoration(
//                      hintText: exerTitle,
//                      filled: false,
//                      fillColor: Colors.grey[100],
//                      contentPadding: new EdgeInsets.all(5.0)
//                  ),
//                ),
//                new TextField(
//                  controller: repsController,
//                  decoration: new InputDecoration(
//                      hintText: exerReps,
//                      filled: false,
//                      fillColor: Colors.grey[100],
//                      contentPadding: new EdgeInsets.all(5.0)
//                  ),
//                ),
//                new TextField(
//                  controller: setsController,
//                  decoration: new InputDecoration(
//                      hintText: exerSets,
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
//                          exerController.clear(); // makes sure there isn't leftover text from the last input
//                          repsController.clear();
//                          setsController.clear();
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
//  _updateCompGoalDialog(int index)
//  {
//    showDialog(
//      context: context,
//      child: SimpleDialog(
//          title: Text("Update your Exercise"),
//          titlePadding: EdgeInsets.all(10.0),
//          contentPadding: EdgeInsets.all(10.0),
//          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
//          children: <Widget>[
//            new Column(
//              children: <Widget>[
//                new TextField(
//                  controller: exerCompController,
//                  decoration: new InputDecoration(
//                      hintText: exerTitle,
//                      filled: false,
//                      fillColor: Colors.grey[100],
//                      contentPadding: new EdgeInsets.all(5.0)
//                  ),
//                ),
//                new TextField(
//                  controller: repsCompController,
//                  decoration: new InputDecoration(
//                      hintText: exerReps,
//                      filled: false,
//                      fillColor: Colors.grey[100],
//                      contentPadding: new EdgeInsets.all(5.0)
//                  ),
//                ),
//                new TextField(
//                  controller: setsCompController,
//                  decoration: new InputDecoration(
//                      hintText: exerSets,
//                      filled: false,
//                      fillColor: Colors.grey[100],
//                      contentPadding: new EdgeInsets.all(5.0)
//                  ),
//                ),
//                new Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget> [
//                      new RaisedButton(
//                        onPressed: () => _enterCompButtonUpdate(index),
//                        child: new Text('Enter'),
//                        color: Colors.blue[100],
//                      ),
//                      new RaisedButton(
//                        onPressed: () {
//                          exerCompController.clear(); // makes sure there isn't leftover text from the last input
//                          repsCompController.clear();
//                          setsCompController.clear();
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
//  _deleteGoal(int index)
//  {
//    setState(() {
//      exerTitle = exer.removeAt(index);
//      exerCompleted.add(exerTitle);
//      exerReps = exerRep.removeAt(index);
//      exerRepsCompleted.add(exerReps);
//      exerSets = exerSet.removeAt(index);
//      exerSetsCompleted.add(exerSets);
//
//      exerCompIndex++;
////      print(goals);
////      print(goalDescriptions);
//      print(exerCompleted);
//      print(exerRepsCompleted);
//      print(exerSetsCompleted);
//    });
//  }
//
//  _redoGoal(int index)
//  {
//    setState(() {
//      exerTitle = exerCompleted.removeAt(index);
//      exer.add(exerTitle);
//      exerReps = exerRepsCompleted.removeAt(index);
//      exerRep.add(exerReps);
//      exerSets = exerSetsCompleted.removeAt(index);
//      exerSet.add(exerSets);
//
//      exerIndex++;
////      print(goals);
////      print(goalDescriptions);
//      //print(exer);
//      //print(exerReps);
//      //print(exerSets);
//    });
//  }
//
//  _deleteCompletedGoal(int index)
//  {
//    setState(() {
//      exerTitle = exerCompleted.removeAt(index);
//      //exer.add(exerTitle);
//      exerRepsCompleted.removeAt(index);
//      //exerRep.add(exerReps);
//      exerSetsCompleted.removeAt(index);
//      //exerSet.add(exerSets);
//
//      exerCompIndex--;
////      print(goals);
////      print(goalDescriptions);
//      //print(exer);
//      //print(exerReps);
//      //print(exerSets);
//    });
//  }
//
//
//  _buildActiveRow(int index)
//  {
//    return new GestureDetector(
//        onTap: ()
//        {
//          exerIndex = index;
//          _updateGoalDialog(exerIndex);
//        },
//        child: Card (
//          color: Colors.blue[100],
//          elevation : 4,
//          child : Container(
//              padding: EdgeInsets.only(left: 10.0, top: 10.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Expanded(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
//                      children: <Widget>[
//                        Text(
//                            exer[index],
//                            textAlign: TextAlign.left,
//                            style: TextStyle(
//                                fontSize: 30.0,
//                                fontWeight: FontWeight.bold
//                            )
//                        ),
//                        Text(
//                            "Reps: ${exerRep[index]} ",
//                            style: TextStyle(
//                              fontSize: 20.0,
//                              fontStyle: FontStyle.italic,
//                            )
//                        ),
//                        Text(
//                            "Sets: ${exerSet[index]}",
//                            style: TextStyle(
//                              fontSize: 20.0,
//                              fontStyle: FontStyle.italic,
//                            )
//                        ),
//                      ],
//                    ),
//                  ),
//                  IconButton(
//                      icon: Icon(Icons.check),
//                      onPressed: () => _deleteGoal(index)
//                  )
//                ],
//              )
//          )
//        )
//    );
//  }
//  _buildCompRow(int index)
//  {
//    return new GestureDetector(
//        onTap: ()
//        {
//          exerIndex = index;
//          _updateCompGoalDialog(exerIndex);
//        },
//        child: Card(
//        color: Colors.blue[100],
//        elevation: 4,
//          child: Container(
//              padding: EdgeInsets.only(left: 10.0, top: 10.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Expanded(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
//                      children: <Widget>[
//                        Text(
//                            exerCompleted[index],
//                            textAlign: TextAlign.left,
//                            style: TextStyle(
//                                fontSize: 30.0,
//                                fontWeight: FontWeight.bold
//                            )
//                        ),
//                        Text(
//                            "Reps: ${exerRepsCompleted[index]}",
//                            style: TextStyle(
//                              fontSize: 20.0,
//                              fontStyle: FontStyle.italic,
//                            )
//                        ),
//                        Text(
//                            "Sets: ${exerSetsCompleted[index]}",
//                            style: TextStyle(
//                              fontSize: 20.0,
//                              fontStyle: FontStyle.italic,
//                            )
//                        ),
//                      ],
//                    ),
//                  ),
//                  IconButton(
//                      icon: Icon(Icons.refresh),
//                      onPressed: () => _redoGoal(index)
//                  ),
//                  IconButton(
//                      icon: Icon(Icons.delete),
//                      onPressed: () => _deleteCompletedGoal(index)
//                  )
//                ],
//              )
//          )
//        )
//    );
//  }
//
  _addGoalDialog()
  {
    showDialog(
      context: context,
      child: SimpleDialog(
          title: Text("Enter an exercise"),
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
                  controller: exerController,
                  decoration: new InputDecoration(
                      labelText: "Exercise",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.all(5.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                  ),
                ),
                new SizedBox(
                  height: 5,
                ),
                new TextField(
                  controller: repsController,
                  decoration: new InputDecoration(
                      hintText: hintReps,
//                      labelText: hintReps,
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
                  controller: setsController,
                  decoration: new InputDecoration(
                      hintText: hintSets,
//                      labelText: hintSets,
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
                  controller: weightsController,
                  decoration: new InputDecoration(
                      labelText: "Weight",
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
                          exerController.clear(); // makes sure there isn't leftover text from the last input
                          repsController.clear();
                          setsController.clear();
                          weightsController.clear();
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
    if(exerController.text == '')
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
      exerController.clear(); // makes sure there isn't leftover text from the last input
      repsController.clear();
      setsController.clear();
      weightsController.clear();
      Navigator.pop(context); // closes dialog when enter button is pressed
    }
  }

  _commitGoal()
  {
    //TODO update for adding to firebase with workout class
    Workout newWorkout = new Workout();

    newWorkout.workoutName = exerController.text;
    newWorkout.reps = int.parse(repsController.text);
    newWorkout.sets = int.parse(setsController.text);
    newWorkout.weight = int.parse(weightsController.text);

    var doc = firebaseDB.collection(userID).document("plans").collection("plans").document();

    firebaseDB.runTransaction((transaction) async {
      await transaction.set(
        doc, newWorkout.toMap());
    });
  }

  buildStream(){
    return StreamBuilder(
        stream: firebaseDB.collection(userID).document("plans").collection("plans").snapshots(),
        builder: (context, snapshot) {
          //print(snapshot.data.documents[0]['name']);
          buildActive(snapshot);
          return ListView.builder(
              itemCount: workoutNames.length,
              itemBuilder: (context, index){
                return Card(
                  color: Colors.blue[100],
                  elevation: 2.0,
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                  //snapshot.data['name'].toString(),
                                  "${workoutNames[index]}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                      //snapshot.data['sets'].toString(),
                                      "${workoutSets[index]}",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontStyle: FontStyle.italic,
                                      )
                                  ),
                                  Text(" sets")
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                      //snapshot.data['reps'].toString(),
                                      "${workoutReps[index]}",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontStyle: FontStyle.italic,
                                      )
                                  ),
                                  Text(" reps")
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                      //snapshot.data['weight'].toString(),
                                      "${workoutWeights[index]}",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontStyle: FontStyle.italic,
                                      )
                                  ),
                                  Text(" lbs")
                                ],
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.check),
                              //onPressed: () => _moveGoal(index)
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              //onPressed: () => _deleteGoal(index)
                            )
                          ],
                        )
                      ],
                    )
                  )
                  /*
                  ListTile(
                    leading: GestureDetector(
                      child: checkBox,
                      onTap: ()  {
                        print("finished ${workoutList[index]}");
                      },
                    ),
                    title: Text(workoutList[index]),
                    trailing: GestureDetector(
                      child: Icon(Icons.delete, color: Colors.grey),
                      onTap: (){
                        print("deleting ${workoutList[index]}");
                      },
                    ),
                    onTap: (){
                      print("${workoutList[index]} tapped ");
                    },

                  ),
                  */
                  //)
                );
              }
          );
        }
    );
  }

  buildActive(AsyncSnapshot<QuerySnapshot> snap)
  {
    print("CALLING");

    if(snap.data == null)
      print("snap is null");
    else {
      print("snap is not null: ${snap.data}");
      workoutNames = snap.data.documents.map((doc) => doc['name']).toList();
      workoutReps = snap.data.documents.map((doc) => doc['reps']).toList();
      workoutSets = snap.data.documents.map((doc) => doc['sets']).toList();
      workoutWeights = snap.data.documents.map((doc) => doc['weight']).toList();
    }
    print(workoutNames);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        body: DefaultTabController(
            length: 2,
            child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: _addGoalDialog,
                  child: Icon(Icons.add),
                ),
                appBar: AppBar(
                  actions: <Widget>[
                    PopupMenuButton<int>(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            child: Text("Select a goal"),
                            enabled: false,
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Text("Lose Weight"),
                          ),
                          PopupMenuItem(
                          value: 2,
                          child: Text("Maintain"),
                          ),
                          PopupMenuItem(
                            value: 3,
                            child: Text("Gain Muscle"),
                          ),
                        ],
                      elevation: 50.0,
                      offset: Offset(0.0, 375.0),
                      initialValue: _buttonValue,
                      onSelected: (value) {
                        if (value == 1) {
                          setState(() {
                            _buttonValue = 1;
                          });
                          hintSets = "Recommended Sets: 6-8";
                          hintReps = "Recommended Reps: 10-20";
                        }
                        else if (value == 2) {
                          setState(() {
                            _buttonValue = 2;
                          });
                          hintSets = "Recommended Sets: 4-6";
                          hintReps = "Recommended Reps: 8-12";
                        }
                        else if (value == 3) {
                          setState(() {
                            _buttonValue = 3;
                          });
                          hintSets = "Recommended Sets: 4-6";
                          hintReps = "Recommended Reps: 2-5";
                        }
                      }
                    )
                  ],
                  bottom: TabBar(tabs: [
                    Tab(text: "Active"),
                    Tab(text: "Completed")
                  ]),
                  title: Text("My Plans"),
                ),
                body: TabBarView(children: [
                  Container(
                      child: userID == "" ? CircularProgressIndicator() : buildStream()
                  ),
                  Container(
                    child: Text("Completed page")
//                      child: ListView.builder(
//                        itemBuilder: (context, index) => _buildCompRow(index),
//                        itemCount: exerCompleted.length,
//                      )
                  )
                ])
            )
        )
    );
  }
}

