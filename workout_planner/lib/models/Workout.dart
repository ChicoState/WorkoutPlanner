class Workout
{
  String _workoutName;
  int _reps;
  int _sets;
  int _weight;

  Workout.set(this._workoutName, this._reps, this._sets, this._weight);

  Workout();

  //getters

  String get workoutName => _workoutName;

  int get reps => _reps;

  int get sets => _sets;

  int get weight => _weight;

  //setters

  set workoutName(name) {
    this._workoutName = name;
  }

  set reps(reps) {
    this._reps = reps;
  }

  set sets(sets) {
    this._sets = sets;
  }

  set weight(weight) {
    this._weight = weight;
  }

  Workout.fromMapObject(Map<String, dynamic> myMap) {
    this._workoutName = myMap['name'];
    this._reps = myMap['reps'];
    this._sets = myMap['sets'];
    this._weight = myMap['weight'];
  }//User.fromMapObjects

  Map<String, dynamic> toMap() {

    //empty map object
    var myMap = Map<String, dynamic>();

    myMap['name'] = _workoutName;
    myMap['reps'] = _reps;
    myMap['sets'] = _sets;
    myMap['weight'] = _weight;

    return myMap;
  }// toMap()

}