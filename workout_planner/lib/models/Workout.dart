class Workout
{
  String _workoutName;
  int _reps;
  int _sets;
  int _weight;
  bool _completed;

  Workout.set(this._workoutName, this._reps, this._sets, this._weight,
      this._completed);

  Workout();

  //getters

  String get workoutName => _workoutName;

  int get reps => _reps;

  int get sets => _sets;

  int get weight => _weight;

  bool get completed => _completed;

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

  set completed(completed){
    this._completed = completed;
  }

  Workout.fromMapObject(Map<String, dynamic> myMap) {
    this._workoutName = myMap['name'];
    this._reps = myMap['reps'];
    this._sets = myMap['sets'];
    this._weight = myMap['weight'];
    this._completed = myMap['completed'];
  }//User.fromMapObjects

  Map<String, dynamic> toMap() {

    //empty map object
    var myMap = Map<String, dynamic>();

    myMap['name'] = _workoutName;
    myMap['reps'] = _reps;
    myMap['sets'] = _sets;
    myMap['weight'] = _weight;
    myMap['completed'] = _completed;

    return myMap;
  }// toMap()

}