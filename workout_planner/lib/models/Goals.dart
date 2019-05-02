class Goal
{
  String _goalName;
  String _goalDescription;
  bool _goalCompleted; // false = goal should be in the active tab, true = goal should be in the completed tab

  Goal.set(this._goalName, this._goalDescription, this._goalCompleted);

  Goal();

  //getters

  String get goalName => _goalName;

  String get goalDescription => _goalDescription;

  bool get goalCompleted => _goalCompleted;

  //setters

  set goalName(name) {
    this._goalName = name;
  }

  set goalDescription(desc) {
    this._goalDescription = desc;
  }

  set goalCompleted(comp) {
    this._goalCompleted = comp;
  }

  Goal.fromMapObject(Map<String, dynamic> myMap) {
    this._goalName = myMap['name'];
    this._goalDescription = myMap['description'];
    this._goalCompleted = myMap['completed'];
  }//User.fromMapObjects

  Map<String, dynamic> toMap() {

    //empty map object
    var myMap = Map<String, dynamic>();

    myMap['name'] = _goalName;
    myMap['description'] = _goalDescription;
    myMap['completed'] = _goalCompleted;

    return myMap;
  }// toMap()

}