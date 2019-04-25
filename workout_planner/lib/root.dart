import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'auth.dart';
import 'myPersonalInfoPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/User.dart';
import 'main.dart';


class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
          user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;

    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_LOGGED_IN:
        return LoginSignUpPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null)
        {
          setInitialInfo(_userId);

          return MyPersonalInfoPage(
            auth: widget.auth,
            onSignedOut: _onSignedOut,
          );

        } else return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}

setInitialInfo(userID) async
{
  final Firestore firebaseDB = Firestore.instance;

  var snap = await firebaseDB.collection(userID).getDocuments();

  if(snap.documents.isEmpty)
  {
    print("root page");
    DocumentReference doc = firebaseDB.collection(userID).document("personalInfo");

    User userObject = new User();

    // set initial values, these will be changed later by the user
    userObject.gender = "none";
    userObject.weight = -1;
    userObject.age = -1;
    userObject.height = -1;

    firebaseDB.runTransaction((transaction) async {
      await transaction.set(
          doc, userObject.toMap());
    });
  }
  //TODO probably want to set goals and workout plan collections here

}
