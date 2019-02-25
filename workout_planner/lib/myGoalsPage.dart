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

  _commitGoal() {
    goalTitle = goalController.text;
    goalDesc = descController.text;
    goals.add(goalTitle);
  }

  _buildRow(int index){
    return new Text();
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
          title: Text("My Goals")
      ),

      //body: Text("Goals Page"),

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
                              Navigator.pop(context);
                            },
                            child: new Text('Enter'),
                            color: Colors.blue[100],
                          ),
                          new RaisedButton(
                            onPressed: () => Navigator.pop(context),
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