import 'package:flutter/material.dart';
import 'main.dart';
import 'package:workout_planner/utils/DBhelper.dart';
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

  int weight = 150;
  int age = 20;
  int heightFeet = 5;
  int heightInch = 3;
  String sex = "Other";

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
          //TODO on initial page load when default data is present, there are errors displaying below
          //TODO   when the page is reloaded it's fine
          //#============================================== start  children
          Text(
            "Personal Information Page",
            style: TextStyle(
              fontSize: 20,)
            ),
          Row(
            children: <Widget>[
              //#============================================== start  children
              //Element 1 - ColorAvatar
              Expanded(
                child: Container(
                  //padding: const EdgeInsets.all(0.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Text("KS"),
                    radius: 50.0,
                  ),
                ),
              ),

            ]
            //#================================================ end children
          ),
//          Row(
//            children: <Widget>[
//              //#============================================== start  children
//              //Element 2 - Username
//              Expanded(
//                child: Container(
//                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                  child: goalForm("Username", "Username", userNameController,
//                      TextInputType.text, TextInputAction.done),
//                ),
//              ),
//
//            ],
//            //#================================================ end children
//          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
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
                  borderSide: BorderSide(color: Colors.white),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: _showWeightDialog,
                  child: Text(
                    "$weight",
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 2.0
                    ),
                  ),
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
            mainAxisAlignment: MainAxisAlignment.start,
            //Height, Age, Sex
            children: <Widget>[
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
                  borderSide: BorderSide(color: Colors.white),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
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
                borderSide: BorderSide(color: Colors.white),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
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
                borderSide: BorderSide(color: Colors.white),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
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
                  borderSide: BorderSide(color: Colors.white),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100.0)),
                  color: Colors.grey,
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

          /*Expanded(
            child: Column(
              children: <Widget>[
                StreamBuilder(      // TODO maybe this is better as a future builder?
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
          ),*/

          RaisedButton(
            onPressed: _saveInfo,
            child: new Text("Submit"),
          )

        ],
      ),
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