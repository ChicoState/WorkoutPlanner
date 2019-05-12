import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';


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
                    color: Colors.grey[50],
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(children: <Widget> [
                          Text("Name: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                          Text("${jsonData[index]['workout']}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)) ],
                        ),

                        Row(children: <Widget> [
                          Text("Muscle: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                          Text("${jsonData[index]['muscle_target']}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)) ],
                        ),

                        Row(children: <Widget> [
                          Text("Equipment: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                          Text("${jsonData[index]['equipment_type']}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)) ],
                        ),

                        Container(
                          child: Linkify(
                            onOpen: (url) async {
                              var url = jsonData[index]['link'];
                              print("On open");
                              if(await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            humanize: true,
                            text: "${jsonData[index]['link']}"
                          )
                        ),

                        //Text("${jsonData[index]['link']}") //TODO make this link clickable

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

