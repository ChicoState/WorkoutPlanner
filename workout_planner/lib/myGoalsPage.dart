import 'package:flutter/material.dart';
import 'main.dart';

class MyGoalsPage extends StatefulWidget
{
  @override
  _MyGoalsPage createState() => _MyGoalsPage();
}

// page to add, track, and edit goals
class _MyGoalsPage extends State<MyGoalsPage>
{
  final goalController = new TextEditingController();
  final descController = new TextEditingController();
  var goalTitle = '';
  var goalDesc = '';
  List<String> goals = [];
  List<String> goalDescriptions = [];

  _commitGoal() {
    goalTitle = goalController.text;
    goalDesc = descController.text;
    goals.add(goalTitle);
    goalDescriptions.add(goalDesc);
  }

  _buildRow(int index){
    return new Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                goals[index],
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
                )
              ),
              Text(
                goalDescriptions[index],
                style: TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic
                )
              ),
            ],
          ),
        ],
       )
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
          title: Text("My Goals")
      ),

      floatingActionButton: FloatingActionButton(
          onPressed:() {
            showDialog(context: context, child:
              SimpleDialog(
                title: Text("Enter a goal."),
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new TextField(
                        controller: goalController,
                        decoration: new InputDecoration(
                          hintText: "Goal",
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: new EdgeInsets.all(5.0)
                        ),
                      ),
                      new TextField(
                        controller: descController,
                        decoration: new InputDecoration(
                            hintText: "Description",
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: new EdgeInsets.all(5.0)
                        ),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget> [
                          new RaisedButton(
                            onPressed: () {
                              _commitGoal();
                              print(goalController.text);
                              print(descController.text);
                              goalController.clear(); // makes sure there isn't leftover text from the last input
                              descController.clear();
                              Navigator.pop(context); // closes dialog when enter button is pressed
                            },
                            child: new Text('Enter'),
                            color: Colors.blue[100],
                          ),
                          new RaisedButton(
                            onPressed: () {
                              goalController.clear(); // makes sure there isn't leftover text from the last input
                              descController.clear();
                              Navigator.pop(context);
                            },
                            child: new Text('Close'),
                            color: Colors.blue[100],
                          )
                        ]
                      ),
                    ],
                  ),
                ]
              ),
            );
          },
          child: Icon(Icons.add),
      ),
      body: new Container (
        child: ListView.builder(
          itemBuilder: (context, index) => _buildRow(index),
          itemCount: goals.length,
        )
      )
    );
  }
}