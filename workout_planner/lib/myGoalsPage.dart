import 'package:flutter/material.dart';
import 'main.dart';

// page to add, track, and edit goals
class MyGoalsPage extends StatelessWidget
{
  final myController = new TextEditingController();
  var goalText = '';

  void setController(){
    myController.text = '';
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
          title: Text("My Goals")
      ),

      body: Text("Goals Page"),

      floatingActionButton: FloatingActionButton(
          onPressed:() {
            showDialog(context: context, child:
              SimpleDialog(
                title: Text("Enter a goal."),
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new TextField(
                        controller: myController,
                        decoration: new InputDecoration(
                          hintText: "Goal",
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: new EdgeInsets.all(5.0)
                        ),
                      ),
                      new TextField(
                        controller: myController,
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
                              goalText = myController.text;
                              print(myController.text);
                              myController.clear();
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
      
    );
  }
}