import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExercisesPage extends StatefulWidget
{
  @override
  _ExercisesPage createState() => _ExercisesPage();
}

class _ExercisesPage extends State<ExercisesPage>
{
  List data;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore Exercises")
      ),

      body: Container(
        child: Center(
          child: FutureBuilder(
            future: DefaultAssetBundle
                    .of(context)
                    .loadString('JSON/exercises.json'),
            builder: (context, snapshot) {
              var jsonData = json.decode(snapshot.data.toString());

              return ListView.builder(
                itemBuilder: (BuildContext context, int index){
                  return Card(
                    margin: EdgeInsets.all(5),
                    color: Colors.blue[50],
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(children: <Widget> [
                          Text("Name: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${jsonData[index]['workout']}") ],
                        ),

                        Row(children: <Widget> [
                          Text("Muscle: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${jsonData[index]['muscle_target']}") ],
                        ),

                        Row(children: <Widget> [
                          Text("Equipment: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${jsonData[index]['equipment_type']}") ],
                        ),

                        Text("${jsonData[index]['link']}" //TODO make this link clickable
                        )
                      ],
                    )
                  );
                },
                itemCount: jsonData == null ? 0 : jsonData.length,
              );
            },
          )
        )
      )
    );
  }
}

