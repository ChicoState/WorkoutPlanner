import 'package:flutter/material.dart';
import 'main.dart';
//import 'package:workout_planner/models/User.dart';
import 'package:workout_planner/utils/DBhelper.dart';
import 'auth.dart';
import 'models/User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



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

final mainReference = FirebaseDatabase.instance.reference();
final FirebaseAuth firebase = FirebaseAuth.instance;
final Firestore firebaseDB = Firestore.instance;

class MyPersonalInfoPageState extends State<MyPersonalInfoPage> {

  //DBhelper db = DBhelper();

  //testing

  //

  MyPersonalInfoPageState();

  // All the TextEditingControllers for each TextFormField
  TextEditingController userNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      print('result: $user');
      var userID = user.uid;

     Firestore.instance.collection('users').document(userID).collection('personalInfo').getDocuments().then((snap) {
       var data = snap.documents[0].data;
       setState(() {
        userNameController.text = data['username'].toString();
        ageController.text = data['age'].toString();
        weightController.text = data['weight'].toString();
        heightController.text = data['height'].toString();
        genderController.text = data['gender'].toString();
       });
     });
    });
//    db.getUser(0).then((result) {
//      print('result: $result');
//      setState((){
//         userNameController.text = result.username;
//         ageController.text = result.age.toString();
//         weightController.text = result.weight.toString();
//         heightController.text = result.height.toString();
//         genderController.text = result.gender;
//      });
//    });
  }

  /*
  name: build
  type: Widget
  return: Scaffold
  desc:
   */
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

//      bottomNavigationBar: BottomAppBar(
//        child: Row(
//          mainAxisSize: MainAxisSize.max,
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            RaisedButton(
//                child: Text("Submit"),
//                color: Theme.of(context).accentColor,
//                onPressed: () => _saveInfo()
//            )
//          ],
//        )
//      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                //#============================================== start  children
                Row(
                  children: <Widget>[
                    //#============================================== start  children
                    //Element 1 - ColorAvatar
                    Expanded(
                      child: Container(
                        //padding: const EdgeInsets.all(0.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.lightBlue,
                          child: Text("KS"),
                          radius: 30.0,
                        ),
                      ),
                    ),

                  ]
                  //#================================================ end children
                ),
                Row(
                  children: <Widget>[
                    //#============================================== start  children
                    //Element 2 - Username
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: goalForm("Username", "Username", userNameController,
                            TextInputType.text, TextInputAction.done),
                      ),
                    ),

                  ],
                  //#================================================ end children
                ),
                Row(
                  children: <Widget>[
                    //#============================================== start  children
                    //Element 3 - Gender
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 100.0),
                        child: goalForm("weight","Weight", weightController,
                            TextInputType.text,
                            TextInputAction.done),
                      )
                    )

                  ],
                  //#================================================ end children
                ),
                Row(
                  //Weight, Age, Sex
                  children: <Widget>[
                    //#============================================== start  children
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        //color: Colors.green,
                        width: 75.0,
                        //padding: const EdgeInsets.all(5.0),
                        child: goalForm("Gender","Gender", genderController,
                            TextInputType.number, TextInputAction.done),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        width: 75.0,
                        child: goalForm("Age","Age", ageController,
                            TextInputType.number, TextInputAction.done),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        width: 75.0,
                        child: goalForm("Height (ft)","Height (ft)", heightController,
                            TextInputType.number, TextInputAction.done),
                      ),
                    ),
                    //#================================================ end children
                  ],
                ),

  //          Expanded(
  //            child: Container(
  //              child: ListView(
  //                children: <Widget>[
  //                  RaisedButton(
  //                      onPressed: _saveInfo,
  //                    child: new Text("Submit"),
  //                  )
  //                ],
  //              ),
  //              padding: EdgeInsets.all(50.0),
  //            ),
  //          ),
          ],
          //#================================================ end children
        ),
      ),

      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: 10.0,),
                Text("Username:"),
                SizedBox(width: 10.0,),
                //Text("${getInfo("user")}")
                Text(userNameController.text)


              ]
            ),
//            SizedBox(height: 10.0),
//            Row(
//                children: <Widget>[
//                  SizedBox(width: 10.0,),
//                  Text("Weight:"),
//                  SizedBox(width: 10.0,),
//                  //Text("${getInfo("weight")}")
//                  Text("${getInfo("weight")}")
//
//                ]
//            ),
//            SizedBox(height: 10.0),
//            Row(
//                children: <Widget>[
//                  SizedBox(width: 10.0,),
//                  Text("Height:"),
//                  SizedBox(width: 10.0,),
//                  //Text("${getInfo("height")}")
//                  Text("${getInfo("height")}")
//
//                ]
//            ),
//            SizedBox(height: 10.0),
//            Row(
//                children: <Widget>[
//                  SizedBox(width: 10.0,),
//                  Text("Gender:"),
//                  SizedBox(width: 10.0,),
//                  //Text("${getInfo("gender")}")
//                  Text("${getInfo("gender")}")
//
//                ]
//            ),
//            SizedBox(height: 10.0),
//            Row(
//                children: <Widget>[
//                  SizedBox(width: 10.0,),
//                  Text("Age:"),
//                  SizedBox(width: 10.0,),
//                  //Text("${getInfo("age")}")
//                  Text("${getInfo("age")}")
//                ]
//            ),
//            SizedBox(height: 10.0),
          ],
        )
      ),
          
      RaisedButton(
        onPressed: _saveInfo,
        child: new Text("Submit"),
      )

      ],),
    );
  } //build

  void _saveInfo() async {
    //determine if insert or update by checking user id
    //if id exists in database then update the info
    //if id does not exist then insert into database
    User userObject = new User();

    userObject.username = userNameController.text;
    userObject.gender = genderController.text;
    userObject.weight = int.parse(weightController.text);
    userObject.age = int.parse(ageController.text);
    userObject.height = int.parse(heightController.text);

    FirebaseUser user = await widget.auth.getCurrentUser();
    var userID = user.uid;

    var snap = await Firestore.instance.collection('users').document(userID).collection('personalInfo').getDocuments();

    // if there's no personal info in the DB for this user, add it with the submitted fields
    if(snap.documents.isEmpty)
    {
      final col = firebaseDB.collection("users").document(userID).collection("personalInfo");

      col.add(userObject.toMap());
    }
    else
      print("not null");
      //TODO update what's in the DB


    /* TODO DON"T DELETE THIS WORKS
    final col = firebaseDB.collection("users").document(userID).collection("personalInfo");

    col.add(userObject.toMap());
    */

    //var snaps = await Firestore.instance.collection('users').document(userID).collection('personalInfo').getDocuments();

    //print(snaps.documents[3].data);



//    Firestore.instance.runTransaction((transaction) async
//    {
//      DocumentSnapshot snap = await Firestore.instance.collection('users').
//        document(userID).get();
//      await transaction.update(snap.reference, {
//        'textInput': inputText
//      });
//    });

    print(user);

    //mainReference.push().set(user.toJson());
  }

  void getInfo(String switchOn) async
  {
    FirebaseUser user = await widget.auth.getCurrentUser();
    var userID = user.uid;

    var snap = await Firestore.instance.collection('users').document(userID).collection('personalInfo').getDocuments();

    if(snap.documents.isEmpty)
    {
      print("ERROR: Nothing in the DB");

//      return "null";
    }
    else
    {
      var data = snap.documents[0].data;

      switch(switchOn)
      {
        case "user":
        {
          userNameController.text = data['username'].toString();
          print(userNameController.text);
          break;
        }
        case "weight":
        {
           weightController.text = data['weight'].toString();
           break;

        }
        case "height":
        {
           heightController.text = data['height'].toString();
           break;
        }
        case "gender":
        {
          genderController.text = data['gender'].toString();
          break;
        }
        case "age":
        {
          ageController.text = data['age'].toString();
          break;
        }
      }
    }
  }
}



/*
 name: goalForm
 type: class
 desc: Initiate MyCustomForm to a Stateful Widget and takes in 5 parameters
  needed to create the TextFormField.
 */
class goalForm extends StatefulWidget {

  //
  String _hintDec;
  String _labelDec;
  TextEditingController _controller = TextEditingController();
  TextInputType _keyboard;
  TextInputAction _action ;

  //Constructor for goalForm
  goalForm(this._hintDec, this._labelDec, this._controller, this._keyboard,
      this._action);
  //Create state for goalForm
  @override
  goalFormState createState() => goalFormState();

  //spagetti code, look @ doc to figure out how to dispose correctly
  //https://flutter.dev/docs/cookbook/forms/text-field-changes
  void controllerDispose(){
    _controller.dispose();
  }
}

/*
 name: goalFormState
 type: class
 return: TextFormField
 desc: Initiate the state of goalForm and returns the TextFormField
 */
class goalFormState extends State<goalForm> {

  DBhelper db = DBhelper();
  User user;
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: widget._hintDec,
        labelText: widget._labelDec,
      ),
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: widget._keyboard,
      controller: widget._controller,
      textInputAction: widget._action,
    );
  }
}



////////////////////////////////////////////////////////////////////////////////
