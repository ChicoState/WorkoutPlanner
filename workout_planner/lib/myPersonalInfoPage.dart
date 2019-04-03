import 'package:flutter/material.dart';
import 'main.dart';
import 'package:workout_planner/models/User.dart';
import 'package:workout_planner/utils/DBhelper.dart';
import 'dart:math';

/*
Goals: Updated 2/27/2019
- Figure out TextEditingController (Widget Tree & Dispose) // ongoing
- Add database statements to TextFormFields // ongoing
- Figure out how to init TextEditingController & how to create an instance
   w/o needing to pass a TextEditingController to goalForm // ongoing
- Need to add RegEx to limit TextForm input and validation (red text) // ongoing
- Need to add a dropdownmenu options for gender input //ongoing

 */
// page to add and update personal weight
class MyPersonalInfoPage extends StatefulWidget {

  final User user = User();

  @override
  MyPersonalInfoPageState createState() => MyPersonalInfoPageState(this.user);
}

class MyPersonalInfoPageState extends State<MyPersonalInfoPage> {

  DBhelper db = DBhelper();
  User user;

  //testing

  //

  MyPersonalInfoPageState(this.user);

  // All the TextEditingControllers for each TextFormField
  TextEditingController userNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  void initState() {
    super.initState();
    db.getUser(1).then((result) {
      print('result: $result');
      setState((){
         userNameController.text = result.username;
         ageController.text = result.age.toString();
         weightController.text = result.weight.toString();
         heightController.text = result.height.toString();
         genderController.text = result.gender;
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
      drawer: NavDrawer(),
      appBar: AppBar(title: Text("Personal Information")),
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
//          Row(
//            //Weight, Age, Sex
//            children: <Widget>[
//              //#============================================== start  children
//              Expanded(
//                child: Container(
//                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
//                  //color: Colors.green,
//                  //padding: const EdgeInsets.all(5.0),
//                  child: goalForm("Weight","Weight", weightController,
//                      TextInputType.number, TextInputAction.done),
//                ),
//              ),
////              Expanded(
////                child: Container(
////                  padding: EdgeInsets.all(20.0),
////                  width: 75.0,
////                  child: goalForm("Age","Age", ageController,
////                      TextInputType.number, TextInputAction.done),
////                ),
////              ),
////              Expanded(
////                child: Container(
////                  padding: EdgeInsets.all(20.0),
////                  width: 75.0,
////                  child: goalForm("Height (ft)","Height (ft)", heightController,
////                      TextInputType.number, TextInputAction.done),
////                ),
////              ),
////              //#================================================ end children
//            ],
//          ),
//          Row(
//            //Weight, Age, Sex
//            children: <Widget>[
//              //#============================================== start  children
//
//              Expanded(
//                child: Container(
//                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
//                  child: goalForm("Age","Age", ageController,
//                      TextInputType.number, TextInputAction.done),
//                ),
//              ),
////              Expanded(
////                child: Container(
////                  padding: EdgeInsets.all(20.0),
////                  width: 75.0,
////                  child: goalForm("Height (ft)","Height (ft)", heightController,
////                      TextInputType.number, TextInputAction.done),
////                ),
////              ),
////              //#================================================ end children
//            ],
//          ),
////          Row(
////            //Weight, Age, Sex
////            children: <Widget>[
////              //#============================================== start  children
////
////              Expanded(
////                child: Container(
////                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
////                  child: goalForm("Height (ft)","Height (ft)", heightController,
////                      TextInputType.number, TextInputAction.done),
////                ),
////              ),
////              //#================================================ end children
////            ],
////          ),
          //Shows the Rest of the Free space on the page to work with.
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

  void _saveInfo() async {
    //determine if insert or update by checking user id
    //if id exists in database then update the info
    //if id does not exist then insert into database

    user.id = 1;
    user.username = userNameController.text;
    user.gender = genderController.text;
    user.weight = int.parse(weightController.text);
    user.age = int.parse(ageController.text);
    user.height = int.parse(heightController.text);

    db.updateToTable(user, "initial_table", "id", 1);
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
