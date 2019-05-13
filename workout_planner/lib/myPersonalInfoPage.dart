import 'package:flutter/material.dart';
import 'main.dart';
import 'auth.dart';
import 'models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_picker/flutter_picker.dart';

// page to add and update personal weight
class MyPersonalInfoPage extends StatefulWidget {
  MyPersonalInfoPage({this.auth, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  MyPersonalInfoPageState createState() => MyPersonalInfoPageState();
}

final FirebaseAuth firebase = FirebaseAuth.instance;
final Firestore firebaseDB = Firestore.instance;

class MyPersonalInfoPageState extends State<MyPersonalInfoPage> {
  String userID = "";
  String userEmail = "";

  MyPersonalInfoPageState();

  int weight = 0;
  int age = 0;
  int heightFeet = 0;
  int heightInch = 0;
  String sex = "Other";

  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        userID = user.uid;
      });
      userEmail = user.email;

      if (userID == "")
        print("ERROR: USERID IS NULL");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Personal Information"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 17.0, color: Colors.white),
            ),
            onPressed: widget._signOut,
          ),
        ],
      ),


      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    //padding: const EdgeInsets.all(0.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.lightBlue,
                      child: userID == "" ? Text("") : Text(
                          "${userEmail[0].toUpperCase()}",
                          style: TextStyle(fontSize: 40)),
                      radius: 50.0,
                    ),
                  ),
                ),
              ]
          ),

          SizedBox(height: 20),
          Text("Your Personal Information:"),
          SizedBox(height: 20),

          displayFirebaseText(),

          Text("Update Your Personal Infomation Below (All values):"),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10.0,),
              Container(
                  child: Text(
                    "Weight:   ",
                    style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 2.0
                    ),
                  )
              ),
              OutlineButton(
                borderSide: BorderSide(color: Colors.black),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: _showWeightDialog,
                child: Text(
                  "$weight",
                  style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 2.0
                  ),
                ),
              ),
            ],
            //#================================================ end children
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            //Height, Age, Sex
            children: <Widget>[
              SizedBox(width: 10.0,),
              Container(
                  child: Text(
                    "Age:       ",
                    style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 2.0
                    ),
                  )
              ),
              OutlineButton(
                borderSide: BorderSide(color: Colors.black),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: _showAgeDialog,
                child: Text(
                  "$age",
                  style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 2.0
                  ),
                ),
              ),
            ],
          ),

          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 10.0,),
                Container(
                    child: Text(
                      "Height: Ft  ",
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 2.0
                      ),
                    )
                ),
                new OutlineButton(
                  borderSide: BorderSide(color: Colors.black),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: _showHeightFeetDialog,
                  child: Text(
                    "$heightFeet",
                    style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 2.0
                    ),
                  ),
                  //color: Colors.grey,
                ),
                Container(
                    child: Text(
                      "  In  ",
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 2.0
                      ),
                    )
                ),
                new OutlineButton(
                  borderSide: BorderSide(color: Colors.black),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: _showHeightInchDialog,
                  child: Text(
                    "$heightInch",
                    style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 2.0
                    ),
                  ),
                  //color: Colors.grey,
                ),
              ]
          ),

          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 10.0,),
                Container(
                    child: Text(
                      "Sex:     ",
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 2.0
                      ),
                    )
                ),
                OutlineButton(
                  borderSide: BorderSide(color: Colors.black),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(100.0)),

                  onPressed: _showSex,
                  child: Text(
                    "$sex",
                    style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 2.0
                    ),
                  ),
                ),
              ]
          ),

          RaisedButton(
            onPressed: _saveInfo,
            child: new Text("Submit"),
          )

        ],
      ),
    );
  } //build

  displayFirebaseText()
  {
    return Expanded(
      child: Column(
        children: <Widget>[
          StreamBuilder(
            stream: firebaseDB.collection(userID).document("personalInfo").snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return CircularProgressIndicator();
              }
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text("Weight:", style: TextStyle(fontSize: 25),),
                        SizedBox(width: 10.0,),
                        userID == "" ? Text("") : Text("${snapshot.data['weight'].toString()} lbs.", style: TextStyle(fontSize: 25))
                      ]
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text("Height:", style: TextStyle(fontSize: 25)),
                        SizedBox(width: 10.0,),
                        userID == "" ? Text("") : Text(
                            "${(snapshot.data['height'] / 12).floor().toString()} ft. ${(snapshot.data['height'] % 12).toString()} in. " ,
                            style: TextStyle(fontSize: 25))
                      ]
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text("Gender:", style: TextStyle(fontSize: 25)),
                        SizedBox(width: 10.0,),
                        userID == "" ? Text("") : Text(snapshot.data['gender'].toString(), style: TextStyle(fontSize: 25))
                      ]
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text("Age:", style: TextStyle(fontSize: 25)),
                        SizedBox(width: 10.0,),
                        userID == "" ? Text("") : Text(snapshot.data['age'].toString(), style: TextStyle(fontSize: 25))
                      ]
                    ),
                    SizedBox(height: 10.0),
                    Row(
                        children: <Widget>[
                          SizedBox(width: 10.0,),
                          Text("BMI:", style: TextStyle(fontSize: 25)),
                          SizedBox(width: 10.0,),
                          userID == ""
                              ? Text("")
                              : Text(
                                  "${((snapshot.data['weight']) * 703 /
                                      (snapshot.data['height'] * snapshot.data['height'])).toStringAsFixed(2)}",
                                  style: TextStyle(fontSize: 25))
                        ]
                    ),
                    SizedBox(height: 10.0),
                  ],
                )
              );
            }
          )
        ],
      )
  );
  }

  _showSex(){
      Picker picker = new Picker(
          adapter: PickerDataAdapter(data: [
            new PickerItem(
              text: Text("Male"),
              value: 0,
                ),
            new PickerItem(
              text: Text("Female"),
              value: 1,
            ),
            new PickerItem(
              text: Text("Other"),
              value: 2,
            )
          ]),
          changeToFirst: true,
          hideHeader: true,
          delimiter: [
            PickerDelimiter(child: Container(
              width: 35.0,
              alignment: Alignment.center,
            ))
          ],
          title: new Text("Select Sex"),
          textAlign: TextAlign.left,
          columnPadding: const EdgeInsets.all(8.0),
          onConfirm: (Picker picker, List value) {
            if(value[0] == 0){
              setState(() => sex = "Male");
            }
            else if(value[0] == 1){
              setState(() => sex = "Female");
            }
            else if(value[0] == 2){
              setState(() => sex = "Other");
            }
          }
      );
      picker.showDialog(context);
    }

  _showWeightDialog(){
    new Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 60, end: 700),
        ]),
        looping: true,
        delimiter: [
          PickerDelimiter(child: Container(
            width: 35.0,
            alignment: Alignment.center,
          ))
        ],
        hideHeader: true,
        title: new Text("Please Select Your Weight"),
        onConfirm: (Picker picker, List value) {
          setState(() => weight = (value[0]+60));
        }
    ).showDialog(context);
  }

  _showAgeDialog(){
    new Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 10, end: 99),
        ]),
        delimiter: [
          PickerDelimiter(child: Container(
            width: 35.0,
            alignment: Alignment.center,
          ))
        ],
        hideHeader: true,
        title: new Text("Please Select Your Age"),
        onConfirm: (Picker picker, List value) {
          setState(() => age = (value[0]+10));
        }
    ).showDialog(context);
  }

  _showHeightFeetDialog(){
    new Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 3, end: 7),
        ]),
        delimiter: [
          PickerDelimiter(child: Container(
            width: 35.0,
            alignment: Alignment.center,
          ))
        ],
        hideHeader: true,
        title: new Text("Please Select Your Height(FT)"),
        onConfirm: (Picker picker, List value) {
          setState(() => heightFeet = (value[0]+3));
        }
    ).showDialog(context);
  }
  _showHeightInchDialog(){
    new Picker(
      adapter: NumberPickerAdapter(data: [
      NumberPickerColumn(begin: 0, end: 11),
      ]),
      delimiter: [
        PickerDelimiter(child: Container(
          width: 35.0,
          alignment: Alignment.center,
        ))
      ],
      hideHeader: true,
      title: new Text("Please Select Your Height(INCH)"),
      onConfirm: (Picker picker, List value) {
        setState(() => heightInch = (value[0]+0));
      }
    ).showDialog(context);
  }

  void _saveInfo() async {

    User userObject = new User();

    userObject.gender = sex;
    userObject.weight = weight;
    userObject.age = age;

    int feetInInches = heightFeet * 12;
    int inches = heightInch;

    userObject.height = feetInInches + inches;

    DocumentReference doc = firebaseDB.collection(userID).document("personalInfo");

    firebaseDB.runTransaction((transaction) async {
      await transaction.update(
          doc, userObject.toMap());
    });
  }
}