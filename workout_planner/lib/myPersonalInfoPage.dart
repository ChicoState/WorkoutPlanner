import 'package:flutter/material.dart';
import 'main.dart';
//import 'package:workout_planner/models/User.dart';
import 'package:workout_planner/utils/DBhelper.dart';
import 'auth.dart';
import 'models/User.dart';
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

final FirebaseAuth firebase = FirebaseAuth.instance;
final Firestore firebaseDB = Firestore.instance;



class MyPersonalInfoPageState extends State<MyPersonalInfoPage>
{
  String userID = "";



  MyPersonalInfoPageState();

  // All the TextEditingControllers for each TextFormField
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      print('result: $user');
      userID = user.uid;

      //TODO this has an error on no data and it doesn't update when new data is added

     Firestore.instance.collection('users').document(userID).collection('personalInfo').getDocuments().then((snap) {
       var data = snap.documents[0].data;
       setState(() {
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
                SizedBox(height: 15.0),
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

//      Expanded(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.start,
//          crossAxisAlignment: CrossAxisAlignment.end,
//          children: <Widget>[
//            Row(
//                children: <Widget>[
//                  SizedBox(width: 10.0,),
//                  Text("Weight:"),
//                  SizedBox(width: 10.0,),
//                  //Text("${getInfo("weight")}")
//                  Text(weightController.text)
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
//                  Text(heightController.text)
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
//                  Text(genderController.text)
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
//                  Text(ageController.text)
//
//                ]
//            ),
//            SizedBox(height: 10.0),
//          ],
//        )
//      ),

      Expanded(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: firebaseDB.document(userID).collection("personalInfo").snapshots(),
              builder: (context, snapshot)
              {
                if(!snapshot.hasData)
                  return Text("Loading data...");
                else
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                            children: <Widget>[
                              SizedBox(width: 10.0,),
                              Text("Weight:"),
                              SizedBox(width: 10.0,),
                              //Text("${getInfo(snapshot)}")

                            ]
                        ),
                        SizedBox(height: 10.0),
                        Row(
                            children: <Widget>[
                              SizedBox(width: 10.0,),
                              Text("Height:"),
                              SizedBox(width: 10.0,),
                              //Text("${getInfo("height")}")
                              //Text(snapshot.data['height'].toString())

                            ]
                        ),
                        SizedBox(height: 10.0),
                        Row(
                            children: <Widget>[
                              SizedBox(width: 10.0,),
                              Text("Gender:"),
                              SizedBox(width: 10.0,),
                              //Text("${getInfo("gender")}")
                              //Text(snapshot.data['gender'].toString())

                            ]
                        ),
                        SizedBox(height: 10.0),
                        Row(
                            children: <Widget>[
                              SizedBox(width: 10.0,),
                              Text("Age:"),
                              SizedBox(width: 10.0,),
                              //Text("${getInfo("age")}")
                              //Text(snapshot.data['age'].toString())

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
      ),


      RaisedButton(
        onPressed: _saveInfo,
        child: new Text("Submit"),
      )

      ],),
    );
  } //build

  void _saveInfo() async
  {
    User userObject = new User();

    userObject.gender = genderController.text;
    userObject.weight = int.parse(weightController.text);
    userObject.age = int.parse(ageController.text);
    userObject.height = int.parse(heightController.text);

    var snap = await Firestore.instance.collection(userID).getDocuments();

    DocumentReference doc = firebaseDB.collection(userID).document("personalInfo");

    // if there's no personal info in the DB for this user, add it with the submitted fields
    if(snap.documents.isEmpty)
    {
      print("empty");
      firebaseDB.runTransaction((transaction) async {
        await transaction.set(
            doc, userObject.toMap());
      });
    }
    else // update the field if it exists
    {
      print("not empty");
      firebaseDB.runTransaction((transaction) async {
        await transaction.update(
            doc, userObject.toMap());
      });
    }
  }

  getInfo(var snapshot)
  {
    //print(snapshot);


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
