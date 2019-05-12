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
    List<Workout> workoutActive = List<Workout>();
    List<Workout> workoutComp = List<Workout>();

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

  _addGoalDialog()
  {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
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
                  keyboardType: TextInputType.number,
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
                  keyboardType: TextInputType.number,
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
                  keyboardType: TextInputType.number,
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
                      ),

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
          builder: (_) => SimpleDialog(
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
    Workout workout = new Workout();

    workout.workoutName = exerController.text;
    workout.reps = int.parse(repsController.text);
    workout.sets = int.parse(setsController.text);
    workout.weight = int.parse(weightsController.text);
    workout.completed = false;


    var doc = firebaseDB.collection(userID).document("plans").collection("plans").document();

    firebaseDB.runTransaction((transaction) async {
      await transaction.set(
        doc, workout.toMap());
    });
  }

  buildStreamComp() {
    return StreamBuilder(
      stream: firebaseDB.collection(userID).document("plans")
          .collection("plansCompleted").snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }
        buildLists(snapshot,true);
        return ListView.builder(
         itemCount: workoutComp.length,
         itemBuilder: (context, index) {
           return buildCards(snapshot,index,true);
         },
        );
      }
    );
  }

  buildCards(var snapshot, int index, bool completed){
    List<Workout> workoutRef = List<Workout>();

    if(!completed){
      workoutRef = workoutActive;
      print(workoutRef);
    }
    else{
      workoutRef = workoutComp;
      print(workoutRef);
    }

    return GestureDetector(
      onTap: () => showUpdateDialog(workoutRef[index].workoutName,
                                    workoutRef[index].reps,
                                    workoutRef[index].sets,
                                    workoutRef[index].weight,
                                    index),
      child: Card(
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
                          "${workoutRef[index].workoutName}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            //snapshot.data['reps'].toString(),
                              "${workoutRef[index].reps}",
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
                            //snapshot.data['sets'].toString(),
                              "${workoutRef[index].sets}",
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
                            //snapshot.data['weight'].toString(),
                              "${workoutRef[index].weight}",
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
                      icon: workoutRef[index].completed == true
                          ? Icon(Icons.arrow_back)
                          : Icon(Icons.check),
                      onPressed: () =>
                          workoutRef[index].completed == true
                            ? _switchSides(index,true)
                            : _switchSides(index,false)
                      //onPressed: () => _moveGoal(index)
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteFromFB(index,
                          workoutRef[index].completed)
                    )
                  ],
                )
              ],
            )
        )
      )

    );
  }
  buildStream(){
    return StreamBuilder(
        stream: firebaseDB.collection(userID).document("plans").collection("plans").snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          buildLists(snapshot, false);
          return ListView.builder(
              itemCount: workoutActive.length,
              itemBuilder: (context, index){
               return buildCards(snapshot, index, false);
              }
          );
        }
    );
  }

  buildLists(AsyncSnapshot<QuerySnapshot> snap, completed)
  {
    Workout work;
    if(!completed){
      workoutActive = snap.data.documents.map((doc) => (
      work = Workout.set(doc['name'],doc['reps'],doc['sets'],doc['weight'],
      doc['completed'])
      )).toList();
    }
    else{
      workoutComp = snap.data.documents.map((doc) => (
          work = Workout.set(doc['name'],doc['reps'],doc['sets'],doc['weight'],
          doc['completed'])
      )).toList();
    }
  }

  showUpdateDialog(name, reps, sets, weight, index)
  {
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return AlertDialog(
          title: Text("Update Workout"),
          content: Container(
            height: 300,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Exercise", style: TextStyle(fontSize: 20.0)),
                    SizedBox(width: 10),
                    Flexible(
                        child: TextFormField(
                            controller: exerController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5.0)
                            )
                        )
                    )
                  ],
                ),

                SizedBox(height: 15),

                Row(
                  children: <Widget>[
                    Text("Reps", style: TextStyle(fontSize: 20.0)),
                    SizedBox(width: 10),
                    Flexible(
                        child: TextFormField(
                            controller: repsController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5.0)
                            )
                        )
                    )
                  ],
                ),

                SizedBox(height: 15),

                Row(
                  children: <Widget>[
                    Text("Sets", style: TextStyle(fontSize: 20.0)),
                    SizedBox(width: 10),
                    Flexible(
                        child: TextFormField(
                            controller: setsController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5.0)
                            )
                        )
                    )
                  ],
                ),

                SizedBox(height: 15),

                Row(
                  children: <Widget>[
                    Text("Weight", style: TextStyle(fontSize: 20.0)),
                    SizedBox(width: 10),
                    Flexible(
                        child: TextFormField(
                            controller: weightsController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5.0)
                            )
                        )
                    )
                  ],
                ),

              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black)
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),

                SizedBox(width: 15),

                RaisedButton(
                    child: Text(
                        "Update Goal",
                        style: TextStyle(color: Colors.black)
                    ),
                    onPressed: () => updateWorkout(name, reps, sets, weight, index)
                ),
              ],
            )
          ],
        );
      }
    );

  }

  updateWorkout(name, reps, sets, weight, index)
  {
    Workout newWorkout = new Workout();

    exerController.text.isEmpty ?
      newWorkout.workoutName = name :
        newWorkout.workoutName = exerController.text;

    repsController.text.isEmpty ?
      newWorkout.reps = reps :
        newWorkout.reps = int.parse(repsController.text);

    setsController.text.isEmpty ?
      newWorkout.sets = sets :
        newWorkout.sets = int.parse(setsController.text);

    weightsController.text.isEmpty ?
      newWorkout.weight = weight :
        newWorkout.weight = int.parse(weightsController.text);

    var foundDocID;
    var doc;

    firebaseDB.collection(userID).document("plans").collection("plans").snapshots().listen((snapshot) async
    {
      foundDocID = snapshot.documents.elementAt(index).documentID.toString();

      doc = firebaseDB.collection(userID).document("plans").collection("plans").document(foundDocID);
    });

    try{
      firebaseDB.runTransaction((transaction) async {
        await transaction.update(
          doc, newWorkout.toMap());
      });
    }catch(e){
      print("error updating plans, printing error");
      print(e);
    }

    exerController.clear();
    setsController.clear();
    repsController.clear();
    weightsController.clear();

    Navigator.pop(context);

  }

  _switchSides(int index, bool completed){
    Workout work;
    String col = "";
    if(!completed) {
      col = "plansCompleted";
      work = workoutActive[index];
      workoutActive.removeAt(index);
      _deleteFromFB(index, work.completed);

      work.completed = true;
      workoutComp.add(work);
    }
    else{
      col = "plans";
      work = workoutComp[index];
      workoutComp.removeAt(index);
      _deleteFromFB(index, work.completed);

      work.completed = false;
      workoutActive.add(work);
    }
    var doc = firebaseDB.collection(userID).document("plans")
        .collection(col).document();

    firebaseDB.runTransaction((transaction) async {
      await transaction.set(
          doc, work.toMap());
    });
  }

  _deleteFromFB(int index, bool complete){

    var foundDocID;
    String col = "";
    complete == false ? col = "plans" : col = "plansCompleted";

    print("index is at $index and collection is $col");
    var doc;

    firebaseDB.collection(userID).document("plans").collection(col).snapshots().listen((snapshot) async
    {
      foundDocID = snapshot.documents.elementAt(index).documentID.toString();

      doc = firebaseDB.collection(userID).document("plans").collection(col).document(foundDocID);

    });

    firebaseDB.runTransaction((transaction) async {
      await transaction.delete(doc);
    });

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
                    child: userID == "" ? CircularProgressIndicator() : buildStreamComp()
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

