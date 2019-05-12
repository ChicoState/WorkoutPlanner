import 'package:flutter/material.dart';
import 'main.dart';
import 'models/Goals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';


class MyGoalsPage extends StatefulWidget
{
  MyGoalsPage({this.auth});

  final BaseAuth auth;

  @override
  _MyGoalsPage createState() => _MyGoalsPage();
}

final Firestore firebaseDB = Firestore.instance;

// page to add, track, and edit goals
class _MyGoalsPage extends State<MyGoalsPage> {
  final goalController = new TextEditingController();
  final descController = new TextEditingController();
  List<Goal> goalList = List<Goal>();
  List<Goal> goalListComp = List<Goal>();
  String userID = "";


  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {

      setState(() {
        userID = user.uid;

      });
      if(userID == "")
        print("ERROR: USERID IS NULL");
    });
  }

  _addGoalDialog() {
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
                    children: <Widget>[
                      new RaisedButton(
                        onPressed: () {
                          goalController
                              .clear(); // makes sure there isn't leftover text from the last input
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

  _enterButton() {
    if (goalController.text == '') {
      showDialog(
          context: context,
          child: SimpleDialog(
            title: Text(
                "Error",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                )
            ),
            titlePadding: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
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
    else {
      _commitGoal();
      goalController.clear(); // makes sure there isn't leftover text from the last input
      descController.clear();
      Navigator.pop(context); // closes dialog when enter button is pressed
    }
  }

  _commitGoal() async
  {
    Goal newGoal = new Goal();

    newGoal.goalName = goalController.text;
    newGoal.goalDescription = descController.text;
    newGoal.goalCompleted = false;

    //FirebaseUser user = await FirebaseAuth.instance.currentUser();
    //String userID = user.uid;

    // yeah, this is dumb but it works
    var doc = firebaseDB.collection(userID).document("goals").collection("goals").document();

    firebaseDB.runTransaction((transaction) async {
      await transaction.set(
          doc, newGoal.toMap());
    });
  }

  buildStream(){
    return StreamBuilder(
        stream: firebaseDB.collection(userID).document("goals").collection("goals").snapshots(),
        builder: (context, snapshot) {
          buildActive(snapshot);
          return ListView.builder(
              itemCount: goalList.length,
              itemBuilder: (context, index){
                return buildCard(snapshot, index, false);
              }
          );
        }
    );
  }

  buildStreamComp(){
    return StreamBuilder(
        stream: firebaseDB.collection(userID).document("goals")
            .collection("goalsCompleted").snapshots(),
        builder: (context, snapshot) {
          buildComp(snapshot);
          return ListView.builder(
              itemCount: goalListComp.length,
              itemBuilder: (context, index){
                return buildCard(snapshot, index, true);
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
      Goal goal = Goal();

      //lol this function is magic
      goalList = snap.data.documents
        .map((doc) => (
           goal = Goal.set(doc['name'],doc['description'],doc['completed'])))
          .toList();

    }//else

    print(goalList);
    print("end buildActive");
  }

  buildComp(AsyncSnapshot<QuerySnapshot> snap)
  {
    print("CALLING");

    if(snap.data == null)
      print("snap is null");
    else {
      print("snap is not null: ${snap.data}");
      Goal goal = Goal();

      //lol this function is magic
      goalListComp = snap.data.documents
          .map((doc) => (
          goal = Goal.set(doc['name'],doc['description'],doc['completed'])))
          .toList();
    }//else

    print(goalListComp);
    print("end buildComp");
  }

  buildCard(var snapshot, int index, bool completed){
    //create List reference
    List<Goal> goalListRef = List<Goal>();

    //
    if(completed){
      goalListRef = goalListComp;
    }
    else{
      goalListRef = goalList;
    }

    return Card(
      color: Colors.blue[100],
      elevation: 2.0,
      child: ListTile(
        leading: GestureDetector(
          child: goalListRef[index].goalCompleted == false
          ? Icon(Icons.check_box_outline_blank)
          : Icon(Icons.check_box),
          onTap: () {
            print("finished ${goalListRef[index]}");
            goalListRef[index].goalCompleted == false
            ? _addToComp(goalListRef[index], index)
            : _addToActive(goalListRef[index], index);
            //print(snapshot.data.documents[index]['name']);
          },
        ),
        title: Text(goalListRef[index].goalName),
        subtitle: Text(goalListRef[index].goalDescription),
        trailing: GestureDetector(
          child: Icon(Icons.delete, color: Colors.grey),
          onTap: () {
            //print("deleting ${goalListRef[index]}");
            _deleteFromFB(index, goalListRef[index].goalCompleted);
          },
        ),
        onTap: () {
          showUpdateDialog(goalListRef[index].goalName,
                           goalListRef[index].goalCompleted,
                           goalListRef[index].goalCompleted,
                           index);
        },
      ),
    );
  }

  showUpdateDialog(name, desc, comp, index)
  {
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return AlertDialog(
          title: Text("Update Goal"),
          content: Container(
            height: 150,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Goal", style: TextStyle(fontSize: 20.0)),
                    SizedBox(width: 10),
                    Flexible(
                        child: TextFormField(
                            controller: goalController,
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
                    Text("Description", style: TextStyle(fontSize: 20.0)),
                    SizedBox(width: 10),
                    Flexible(
                        child: TextFormField(
                            maxLines: 2,
                            controller: descController,
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
                  onPressed: () => updateGoal(name, desc, comp, index)
                ),
              ],
            )
          ],
        );
      }
    );
  }

  updateGoal(name, desc, comp, index)
  {
    Goal newGoal = new Goal();

    goalController.text.isEmpty ?
      newGoal.goalName = name :
        newGoal.goalName = goalController.text;

    descController.text.isEmpty ?
      newGoal.goalDescription = desc :
        newGoal.goalDescription = descController.text;

    newGoal.goalCompleted = comp;

    var foundDocID;
    var doc;

    firebaseDB.collection(userID).document("goals").collection("goals").snapshots().listen((snapshot) async
    {
      foundDocID = snapshot.documents.elementAt(index).documentID.toString();

      doc = firebaseDB.collection(userID).document("goals").collection("goals").document(foundDocID);
    });

    try{
      firebaseDB.runTransaction((transaction) async {
        await transaction.update(
          doc, newGoal.toMap());
      });
    }catch(e){
      print("error updating goals, printing error");
      print(e);
    }

    goalController.clear();
    descController.clear();

    Navigator.pop(context);

  }

  _addToComp(Goal goal, int index){

    //remove from firebase & local list
    goalList.removeAt(index);
    _deleteFromFB(index, goal.goalCompleted);

    //add to completed list
    goal.goalCompleted = true;
    goalListComp.add(goal);

    //add to new collection/document
    var doc = firebaseDB.collection(userID).document("goals")
        .collection("goalsCompleted").document();

    firebaseDB.runTransaction((transaction) async {
      await transaction.set(
          doc, goal.toMap());
    });

  }

  _addToActive(Goal goal, int index){

    //remove from firebase & local list
    goalListComp.removeAt(index);
    _deleteFromFB(index, goal.goalCompleted);

    //add to completed list
    goal.goalCompleted = false;
    goalListComp.add(goal);

    //add to new collection/document
    var doc = firebaseDB.collection(userID).document("goals")
        .collection("goals").document();

    firebaseDB.runTransaction((transaction) async {
      await transaction.set(
          doc, goal.toMap());
    });

  }
  _deleteFromFB(int index, bool complete){

    var foundDocID;
    String col = "";
    complete == false ? col = "goals" : col = "goalsCompleted";

    var doc;

    firebaseDB.collection(userID).document("goals").collection(col).snapshots().listen((snapshot) async
    {
      foundDocID = snapshot.documents.elementAt(index).documentID.toString();

      doc = firebaseDB.collection(userID).document("goals").collection(col).document(foundDocID);

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
            onPressed: () => _addGoalDialog(),
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
            Container(
              child: userID == "" ? CircularProgressIndicator() : buildStream()
            ),
            Container (
              child: userID == "" ? CircularProgressIndicator() : buildStreamComp()
              //child: buildActive()
            ),
            ])
        )
      )
    );
  }
}





