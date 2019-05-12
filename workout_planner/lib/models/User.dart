class User {

  //private variables
  String _gender;
  int _weight;
  int _age;
  int _height; //in inches

  //Add options later
  User.set(this._gender, this._weight, this._age, this._height);

  User();

  //getters
  String get gender => _gender;

  int get weight => _weight;

  int get age => _age;

  int get height => _height;

  //setters

  set gender(String newGender) {
    if (newGender == 'Male') {
      this._gender = "Male";
    }
    else if (newGender == 'Female') {
      this._gender = "Female";
    }
    else if(newGender == 'Other') {
      this._gender = "Other";
    }
  }

  set weight(int newWeight) {
    this._weight = newWeight;
  }

  set age(int newAge) {
    this._age = newAge;
  }

  set height(int newHeight) {
    this._height = newHeight;
  }

  toJson()
  {
    return {
      "gender"   : _gender,
      "weight"   : _weight,
      "age"      : _age,
      "height"   : _height
    };
  }

  User.fromMapObject(Map<String, dynamic> myMap) {
    this._gender = myMap['gender'];
    this._weight = myMap['weight'];
    this._age = myMap['age'];
    this._height = myMap['height'];
  }//User.fromMapObjects

  Map<String, dynamic> toMap() {

    //empty map object
    var myMap = Map<String, dynamic>();

    myMap['gender'] = _gender;
    myMap['weight'] = _weight;
    myMap['age'] = _age;
    myMap['height'] = _height;

    return myMap;
  }// toMap()

}