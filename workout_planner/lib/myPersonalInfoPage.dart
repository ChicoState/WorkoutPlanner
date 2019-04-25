import 'package:flutter/material.dart';
import 'main.dart';
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

  var firebaseAge = "";
  var firebaseWeight = "";
  var firebaseHeight = "";
  var firebaseGender = "";

  MyPersonalInfoPageState();

  // All the TextEditingControllers for each TextFormField
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {

      userID = user.uid;

      if(userID == "")
        print("ERROR: USERID IS NULL");

     Firestore.instance.collection(userID).getDocuments().then((snap) {
       var data = snap.documents[0].data;
       setState(() {
        ageController.text = data['age'].toString();
        weightController.text = data['weight'].toString();
        heightController.text = data['height'].toString();
        genderController.text = data['gender'].toString();
       });
     });
    });
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
              ],
          //#================================================ end children
            ),
          ),

          //TODO on initial page load when default data is present, there are errors displaying below
          //TODO   when the page is reloaded it's fine
          Expanded(
            child: Column(
              children: <Widget>[
                StreamBuilder(
                  stream: firebaseDB.collection(userID).document("personalInfo").snapshots(),
                  builder: (context, snapshot) {
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
                              Text(snapshot.data['weight'].toString())
                            ]
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 10.0,),
                              Text("Height:"),
                              SizedBox(width: 10.0,),
                              Text(snapshot.data['height'].toString())
                            ]
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 10.0,),
                              Text("Gender:"),
                              SizedBox(width: 10.0,),
                              Text(snapshot.data['gender'].toString())
                            ]
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 10.0,),
                              Text("Age:"),
                              SizedBox(width: 10.0,),
                              Text(snapshot.data['age'].toString())
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

        ],
      ),
    );
  } //build

  void _saveInfo() async
  {
    User userObject = new User();

    userObject.gender = genderController.text;
    userObject.weight = int.parse(weightController.text);
    userObject.age = int.parse(ageController.text);
    userObject.height = int.parse(heightController.text);

    //var snap = await firebaseDB.collection(userID).getDocuments();

    DocumentReference doc = firebaseDB.collection(userID).document("personalInfo");

    firebaseDB.runTransaction((transaction) async {
      await transaction.update(
          doc, userObject.toMap());
    });

    // if there's no personal info in the DB for this user, add it with the submitted fields
//    if(snap.documents.isEmpty)//TODO this won't work in the future when there are multiple documents
//    {
//      print("empty");
//      firebaseDB.runTransaction((transaction) async {
//        await transaction.set(
//            doc, userObject.toMap());
//      });
//    }
//    else // update the field if it exists
//    {
//      print("not empty");
//      firebaseDB.runTransaction((transaction) async {
//        await transaction.update(
//            doc, userObject.toMap());
//      });
//    }
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
