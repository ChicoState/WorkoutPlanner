import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


class WorkoutPlanPage extends StatefulWidget
{
  @override
  _WorkoutPlanPage createState() => _WorkoutPlanPage();
}


class _WorkoutPlanPage extends State<WorkoutPlanPage>
{
  final exerController = new TextEditingController();
  final repsController = new TextEditingController();
  final setsController = new TextEditingController();

  final exerCompController = new TextEditingController();
  final repsCompController = new TextEditingController();
  final setsCompController = new TextEditingController();

  int _radioValue;
  String showGoal;

  String hintReps;
  String hintSets;

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

  _commitGoal()
  {
    exerTitle = exerController.text;
    exerReps = repsController.text;
    exerSets = setsController.text;
    if(exerTitle != '')
    {
      exer.add(exerTitle);
      exerRep.add(exerReps);
      exerSet.add(exerSets);
    }
  }

  _commitGoalUpdate(int index)
  {
    exerTitle = exerController.text;
    exerReps = repsController.text;
    exerSets = setsController.text;
    if(exerTitle != '')
    {
      exer[index] = exerTitle;
      exerRep[index] = exerReps;
      exerSet[index] = exerSets;
    }
  }

  _commitCompGoalUpdate(int index)
  {
    exerTitle = exerCompController.text;
    exerReps = repsCompController.text;
    exerSets = setsCompController.text;
    if(exerTitle != '')
    {
      exerCompleted[index] = exerTitle;
      exerRepsCompleted[index] = exerReps;
      exerSetsCompleted[index] = exerSets;
    }
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
      print(exerController.text);
      print(repsController.text);
      print(setsController.text);
      exerController.clear(); // makes sure there isn't leftover text from the last input
      repsController.clear();
      setsController.clear();
      Navigator.pop(context); // closes dialog when enter button is pressed
    }
  }

  _enterButtonUpdate(int index)
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
      _commitGoalUpdate(index);
      print(exerController.text);
      print(repsController.text);
      print(setsController.text);
      exerController.clear(); // makes sure there isn't leftover text from the last input
      repsController.clear();
      setsController.clear();
      Navigator.pop(context); // closes dialog when enter button is pressed
    }
  }

  _enterCompButtonUpdate(int index)
  {
    if(exerCompController.text == '')
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
      _commitCompGoalUpdate(index);
      print(exerCompController.text);
      print(repsCompController.text);
      print(setsCompController.text);
      exerCompController.clear(); // makes sure there isn't leftover text from the last input
      repsCompController.clear();
      setsCompController.clear();
      Navigator.pop(context); // closes dialog when enter button is pressed
    }
  }


  _buildActiveRow(int index)
  {
    new Card (
        color: Colors.blue[100],
        elevation : 4,
        child : Container(
            padding: EdgeInsets.only(left: 10.0, top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                          showGoal,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    ],
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () => _deleteGoal(index)
                )
              ],
            )
        )
    );

    return new GestureDetector(
        onTap: ()
        {
          exerIndex = index;
          _updateGoalDialog(exerIndex);
        },
        child: Card (
          color: Colors.blue[100],
          elevation : 4,
          child : Container(
              padding: EdgeInsets.only(left: 10.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                            exer[index],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        Text(
                            "Reps: ${exerRep[index]} ",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontStyle: FontStyle.italic,
                            )
                        ),
                        Text(
                            "Sets: ${exerSet[index]}",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontStyle: FontStyle.italic,
                            )
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () => _deleteGoal(index)
                  )
                ],
              )
          )
        )
    );
  }
  _buildCompRow(int index)
  {
    return new GestureDetector(
        onTap: ()
        {
          exerIndex = index;
          _updateCompGoalDialog(exerIndex);
        },
        child: Card(
        color: Colors.blue[100],
        elevation: 4,
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
                            exerCompleted[index],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        Text(
                            "Reps: ${exerRepsCompleted[index]}",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontStyle: FontStyle.italic,
                            )
                        ),
                        Text(
                            "Sets: ${exerSetsCompleted[index]}",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontStyle: FontStyle.italic,
                            )
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () => _redoGoal(index)
                  ),
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteCompletedGoal(index)
                  )
                ],
              )
          )
        )
    );
  }

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

  _updateGoalDialog(int index)
  {
    showDialog(
      context: context,
      child: SimpleDialog(
          title: Text("Update your Exercise"),
          titlePadding: EdgeInsets.all(10.0),
          contentPadding: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          children: <Widget>[
            new Column(
              children: <Widget>[
                new TextField(
                  controller: exerController,
                  decoration: new InputDecoration(
                      hintText: exerTitle,
                      filled: false,
                      fillColor: Colors.grey[100],
                      contentPadding: new EdgeInsets.all(5.0)
                  ),
                ),
                new TextField(
                  controller: repsController,
                  decoration: new InputDecoration(
                      hintText: exerReps,
                      filled: false,
                      fillColor: Colors.grey[100],
                      contentPadding: new EdgeInsets.all(5.0)
                  ),
                ),
                new TextField(
                  controller: setsController,
                  decoration: new InputDecoration(
                      hintText: exerSets,
                      filled: false,
                      fillColor: Colors.grey[100],
                      contentPadding: new EdgeInsets.all(5.0)
                  ),
                ),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget> [
                      new RaisedButton(
                        onPressed: () => _enterButtonUpdate(index),
                        child: new Text('Enter'),
                        color: Colors.blue[100],
                      ),
                      new RaisedButton(
                        onPressed: () {
                          exerController.clear(); // makes sure there isn't leftover text from the last input
                          repsController.clear();
                          setsController.clear();
                          Navigator.pop(context);
                        },
                        child: new Text('Cancel'),
                        color: Colors.blue[100],
                      )
                    ]
                ),
              ],
            ),
          ]
      ),
    );
  }

  _updateCompGoalDialog(int index)
  {
    showDialog(
      context: context,
      child: SimpleDialog(
          title: Text("Update your Exercise"),
          titlePadding: EdgeInsets.all(10.0),
          contentPadding: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          children: <Widget>[
            new Column(
              children: <Widget>[
                new TextField(
                  controller: exerCompController,
                  decoration: new InputDecoration(
                      hintText: exerTitle,
                      filled: false,
                      fillColor: Colors.grey[100],
                      contentPadding: new EdgeInsets.all(5.0)
                  ),
                ),
                new TextField(
                  controller: repsCompController,
                  decoration: new InputDecoration(
                      hintText: exerReps,
                      filled: false,
                      fillColor: Colors.grey[100],
                      contentPadding: new EdgeInsets.all(5.0)
                  ),
                ),
                new TextField(
                  controller: setsCompController,
                  decoration: new InputDecoration(
                      hintText: exerSets,
                      filled: false,
                      fillColor: Colors.grey[100],
                      contentPadding: new EdgeInsets.all(5.0)
                  ),
                ),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget> [
                      new RaisedButton(
                        onPressed: () => _enterCompButtonUpdate(index),
                        child: new Text('Enter'),
                        color: Colors.blue[100],
                      ),
                      new RaisedButton(
                        onPressed: () {
                          exerCompController.clear(); // makes sure there isn't leftover text from the last input
                          repsCompController.clear();
                          setsCompController.clear();
                          Navigator.pop(context);
                        },
                        child: new Text('Cancel'),
                        color: Colors.blue[100],
                      )
                    ]
                ),
              ],
            ),
          ]
      ),
    );
  }

  _deleteGoal(int index)
  {
    setState(() {
      exerTitle = exer.removeAt(index);
      exerCompleted.add(exerTitle);
      exerReps = exerRep.removeAt(index);
      exerRepsCompleted.add(exerReps);
      exerSets = exerSet.removeAt(index);
      exerSetsCompleted.add(exerSets);

      exerCompIndex++;
//      print(goals);
//      print(goalDescriptions);
      print(exerCompleted);
      print(exerRepsCompleted);
      print(exerSetsCompleted);
    });
  }

  _redoGoal(int index)
  {
    setState(() {
      exerTitle = exerCompleted.removeAt(index);
      exer.add(exerTitle);
      exerReps = exerRepsCompleted.removeAt(index);
      exerRep.add(exerReps);
      exerSets = exerSetsCompleted.removeAt(index);
      exerSet.add(exerSets);

      exerIndex++;
//      print(goals);
//      print(goalDescriptions);
      //print(exer);
      //print(exerReps);
      //print(exerSets);
    });
  }

  _deleteCompletedGoal(int index)
  {
    setState(() {
      exerTitle = exerCompleted.removeAt(index);
      //exer.add(exerTitle);
      exerRepsCompleted.removeAt(index);
      //exerRep.add(exerReps);
      exerSetsCompleted.removeAt(index);
      //exerSet.add(exerSets);

      exerCompIndex--;
//      print(goals);
//      print(goalDescriptions);
      //print(exer);
      //print(exerReps);
      //print(exerSets);
    });
  }

  _handleRadioValueChanged(int value)
  {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          hintReps = "Enter Reps (Recommended: 4-7)";
          hintSets = "Enter Sets (Recommended: 3-6)";
          showGoal = "Maintain Weight";
          break;
        case 1:
          hintReps = "Enter Reps (Recommended: 3-5)";
          hintSets = "Enter Sets (Recommended: 4-7)";
          showGoal = "Gain Muscle";
          break;
        case 2:
          hintReps = "Enter Reps (Recommended: 8-12)";
          hintSets = "Enter Sets (Recommended: 3-5)";
          showGoal = "Lose Weight";
          break;
      }
    });  }

  _changeGoal()
  {
    showDialog(
      context: context,
      child: SimpleDialog(
        title: Text("Please Select Your Goal"),
        titlePadding: EdgeInsets.all(10.0),
        contentPadding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)
            )
        ),
        children: <Widget>[
          new Row(
            children: <Widget> [
            new Column(
            children: <Widget>[
              new Radio(
                  value: 0,
                 groupValue: _radioValue,
                 onChanged: _handleRadioValueChanged,
                activeColor: Colors.red,

              ),
            ],
            ),
              new Column(
                children: <Widget>[
                  new Text("Maintain")
                ],
              )
          ]
          ),
          new Row(
              children: <Widget> [
                new Column(
                  children: <Widget>[
                    new Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChanged,
                      activeColor: Colors.purple,
                    ),
                  ],
                ),
                new Column(
                  children: <Widget>[
                    new Text("Gain Muscle")
                  ],
                )
              ]
          ),
          new Row(
              children: <Widget> [
                new Column(
                  children: <Widget>[
                    new Radio(
                        value: 2,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChanged,
                      activeColor: Colors.green,

                    ),
                  ],
                ),
                new Column(
                  children: <Widget>[
                    new Text("Lose Weight")
                  ],
                )
              ]
          ),
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        body: DefaultTabController(
            length: 2,
            child: Scaffold(
                floatingActionButton: SpeedDial(
                  animatedIcon: AnimatedIcons.menu_close,
                  animatedIconTheme: IconThemeData(size: 22.0),
                  curve: Curves.bounceIn,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  onOpen: () => print('OPENING DIAL'),
                  onClose: () => print('DIAL CLOSED'),
                  tooltip: 'Speed Dial',
                  heroTag: 'speed-dial-hero-tag',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 8.0,
                  shape: CircleBorder(),
                  children: [
                    SpeedDialChild(
                        child: Icon(Icons.accessibility),
                        backgroundColor: Colors.red,
                        label: 'Goal',
                        onTap: () => _changeGoal(),
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.brush),
                      backgroundColor: Colors.blue,
                      label: 'Plan',
                      onTap:() => _addGoalDialog(),
                    ),
                  ],
                ),
                appBar: AppBar(
                  bottom: TabBar(tabs: [
                    Tab(text: "Active"),
                    Tab(text: "Completed")
                  ]),
                  title: Text("My Plans"),
                ),
                body: TabBarView(children: [
                  new Container (
                      child: ListView.builder(
                        itemBuilder: (context, index) => _buildActiveRow(index),
                        itemCount: exer.length,
                      )
                  ),
                  new Container(
                      child: ListView.builder(
                        itemBuilder: (context, index) => _buildCompRow(index),
                        itemCount: exerCompleted.length,
                      )
                  )
                ])
            )
        )
    );
  }
}
