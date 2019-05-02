import 'package:flutter/material.dart';
import 'main.dart';
//import 'package:workout_planner/models/User.dart';
import 'package:workout_planner/utils/DBhelper.dart';
import 'auth.dart';
import 'models/User.dart';
import 'package:firebase_database/firebase_database.dart';
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

final mainReference = FirebaseDatabase.instance.reference();
final FirebaseAuth firebase = FirebaseAuth.instance;
final Firestore firebaseDB = Firestore.instance;



class MyPersonalInfoPageState extends State<MyPersonalInfoPage> {

  DBhelper db = DBhelper();

  //testing

  //

  MyPersonalInfoPageState();

  // All the TextEditingControllers for each TextFormField
  TextEditingController userNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  int weight = 150;
  int age = 20;
  int heightFeet = 5;
  int heightInch = 3;
  String sex = "Other";

  void initState() {
    super.initState();
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
          //#============================================== start  children
          Text("Personal Information Page"),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  child: Text(
                    "Weight",
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 2.0
                    ),
                  )
              ),
              Expanded(
                child: new FlatButton(
                  onPressed: _showWeightDialog,
                  child: Text(
                    "$weight",
                    style: TextStyle(
                      fontSize: 30,
                      letterSpacing: 2.0
                    ),
                  ),

                )
              ),
              
              //#============================================== start  children
              //Element 3 - Gender
//              Expanded(
//                child: Container(
//                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
//                  child: goalForm("weight","Weight", weightController,
//                      TextInputType.text,
//                      TextInputAction.done),
//                )
//              )

            ],
            //#================================================ end children
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //Height, Age, Sex
            children: <Widget>[
              Container(
                  child: Text(
                    "Age",
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 2.0
                    ),
                  )
              ),
              Expanded(
                child: new FlatButton(
                  onPressed: _showAgeDialog,
                  child: Text(
                    "$age",
                    style: TextStyle(
                        fontSize: 30,
                        letterSpacing: 2.0
                    ),
                  ),
                  color: Colors.grey,
                )
              ),

              //#============================================== start  children
//              Expanded(
//                child: Container(
//                  padding: EdgeInsets.all(20.0),
//                  //color: Colors.green,
//                  width: 75.0,
//                  //padding: const EdgeInsets.all(5.0),
//                  child: goalForm("Gender","Gender", genderController,
//                      TextInputType.number, TextInputAction.done),
//                ),
//              ),
//              Expanded(
//                child: Container(
//                  padding: EdgeInsets.all(20.0),
//                  width: 75.0,
//                  child: goalForm("Age","Age", ageController,
//                         TextInputType.number, TextInputAction.done),
//                ),
//              ),
//              Expanded(
//                child: Container(
//                  padding: EdgeInsets.all(20.0),
//                  width: 75.0,
//                  child: goalForm("Height (ft)","Height (ft)", heightController,
//                      TextInputType.number, TextInputAction.done),
//                ),
//              ),
              //#================================================ end children
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Text(
                  "Height: FEET",
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 2.0
                  ),
                )
              ),
              new FlatButton(
                onPressed: _showHeightFeetDialog,
                child: Text(
                  "$heightFeet",
                  style: TextStyle(
                      fontSize: 30,
                      letterSpacing: 2.0
                  ),
                ),
                color: Colors.grey,
              ),
              Container(
                  child: Text(
                    "INCH",
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 2.0
                    ),
                  )
              ),
              new FlatButton(
                onPressed: _showHeightInchDialog,
                child: Text(
                  "$heightInch",
                  style: TextStyle(
                      fontSize: 30,
                      letterSpacing: 2.0
                  ),
                ),
                color: Colors.grey,
              ),
            ]
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  child: Text(
                    "Sex:",
                    style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 2.0
                    ),
                  )
              ),
              Expanded(
                child: new FlatButton(
                  onPressed: _showSex,
                  child: Text(
                    "$sex",
                    style: TextStyle(
                        fontSize: 30,
                        letterSpacing: 2.0
                    ),
                  ),
                  color: Colors.grey,
                )
              ),
            ]
          ),
          Expanded(
            child: Container(
              child: ListView(
                children: <Widget>[
                  RaisedButton(
                      onPressed: _saveInfo,
                    child: new Text("Submit"),
                  )
                ],
              ),
              padding: EdgeInsets.all(50.0),
            ),
          ),
        ],
        //#================================================ end children

      ),
//      floatingActionButton:
//          FloatingActionButton(onPressed: () {
//            _saveInfo();
//          }, child: Icon(Icons.add)),
    );
  } //build

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

    var snap = await Firestore.instance.collection('users').document(userID).collection('personalInfo').getDocuments();

    print(snap.documents[4].data);
    */


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

}

/*
 name: goalForm
 type: class
 desc: Initiate MyCustomForm to a Stateful Widget and takes in 5 parameters
  needed to create the TextFormField.
 */
class goalForm extends StatefulWidget {

  String _hintDec;
  String _labelDec;
  TextEditingController _controller = TextEditingController();
  TextInputType _keyboard;
  TextInputAction _action;

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




////Age Form
//Expanded(
//child: Container(
//padding: EdgeInsets.all(20.0),
//width: 75.0,
//child: goalForm("Age","Age", ageController,
//TextInputType.number, TextInputAction.done),
//),
//),