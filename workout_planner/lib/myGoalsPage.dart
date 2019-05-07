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

//TODO get userID from current user
//final userID = "5fs7CFXQgFhYRqa6tCWB4ha4O0m1";

// page to add, track, and edit goals
class _MyGoalsPage extends State<MyGoalsPage> {
  final goalController = new TextEditingController();
  final descController = new TextEditingController();
  List<Goal> goalList = List<Goal>();
  List<Goal> goalListComp = List<Goal>();
  var checkBox = Icon(Icons.check_box_outline_blank);
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
                      )
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

//  buildActive() async
//  {
//    FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    String userID = user.uid;
//
//    StreamBuilder(
//      stream: firebaseDB.collection(userID).document("goals").collection("goals").snapshots(),
//      builder: (context, snapshot) {
//        return new GestureDetector(
//          onTap: () {
//            print("tapped");
//            //goalIndex = index;
//            //_updateGoalDialog(goalIndex);
//          },
//          child: Card(
//            color: Colors.blue[100],
//            elevation: 3,
//            margin: EdgeInsets.all(4),
//            child: Container(
//              padding: EdgeInsets.only(left: 10.0, top: 10.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Expanded(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
//                      children: <Widget>[
//                        Text(
//                            snapshot.data['name'].toString(),
//                            textAlign: TextAlign.left,
//                            style: TextStyle(
//                                fontSize: 30.0,
//                                fontWeight: FontWeight.bold
//                            )
//                        ),
//                        Text(
//                            snapshot.data['description'].toString(),
//                            style: TextStyle(
//                              fontSize: 20.0,
//                              fontStyle: FontStyle.italic,
//                            )
//                        ),
//                      ],
//                    ),
//                  ),
//                  IconButton(
//                    icon: Icon(Icons.check),
//                    //onPressed: () => _moveGoal(index)
//                  )
//                ],
//              )
//            )
//          )
//        );
//      }
//    );
//  }
//                child: ListView.builder(
//                  itemBuilder: (context, index) => _buildActiveRow(index),
//                  itemCount: goals.length,
//                )
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
        stream: firebaseDB.collection(userID).document("goals").collection("goals").snapshots(),
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

      for(int index = goalList.length-1; index>-1; index--){
        if(goalList[index].goalCompleted == true) {
            //goalListComp.add(goalList[index]);
            goalList.removeAt(index);
        }
      }
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

    for(int index = goalListComp.length-1; index>-1; index--){
      if(goalListComp[index].goalCompleted == false) {
        //goalListComp.add(goalList[index]);
        goalListComp.removeAt(index);
      }
    }
    print(goalListComp);
    print("end buildComp");
  }

  buildCard(var snapshot, int index, bool completed){
    //create List refrence
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
            child: checkBox,
            onTap: () {
              print("finished ${goalListRef[index]}");
              //print(snapshot.data.documents[index]['name']);
            },
          ),
          title: Text(goalListRef[index].goalName),
          subtitle: Text(goalListRef[index].goalDescription),
          trailing: GestureDetector(
            child: Icon(Icons.delete, color: Colors.grey),
            onTap: () {
              print("deleting ${goalListRef[index]}");
            },
          ),
          onTap: () {
            print("${goalListRef[index]} tapped ");
          },
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





