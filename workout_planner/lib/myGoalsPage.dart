import 'package:flutter/material.dart';
import 'main.dart';
import 'models/Goals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<dynamic> goalList = List<dynamic>();
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
          //print(snapshot.data.documents[0]['name']);
          buildActive(snapshot);
          return ListView.builder(
              itemCount: goalList.length,
              itemBuilder: (context, index){
                return Card(
                  color: Colors.blue[100],
                  elevation: 2.0,
                  child: ListTile(
                    leading: GestureDetector(
                      child: checkBox,
                      onTap: ()  {
                        print("finished ${goalList[index]}");
//                                  setState(() {
//                                    checkBox = Icon(Icons.check_box, color: Colors.grey);
//                                  });
                      },
                    ),
                    title: Text(goalList[index]),
                    trailing: GestureDetector(
                      child: Icon(Icons.delete, color: Colors.grey),
                      onTap: (){
                        print("deleting ${goalList[index]}");
                      },
                    ),
                    onTap: (){
                      print("${goalList[index]} tapped ");
                    },
                  ),
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
      goalList = snap.data.documents
          .map((doc) => doc['name']).toList();
    }
    print(goalList);
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
              child: userID==""?CircularProgressIndicator():buildStream()
            ),
            Container (
              child: Text("Build completed")
              //child: buildActive()
            ),
            ])
        )
      )
    );
  }
}





