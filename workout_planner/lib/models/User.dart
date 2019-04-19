class User {

  //private variables
  String _username;
  String _gender;
  int _weight;
  int _age;
  int _height; //in cm

  //Add options later
  User.set(this._username, this._gender, this._weight, this._age, this._height);

  User();

  //getters
  String get username => _username;

  String get gender => _gender;

  int get weight => _weight;

  int get age => _age;

  int get height => _height;

  //setters

  set username(String newUsername) {
    if (newUsername.length <= 10) {
      this._username = newUsername;
    }
  }

  set gender(String newGender) {
    if (newGender == 'Male' || newGender == 'male') {
      this._gender = newGender;
    }
    else if (newGender == 'Female' || newGender == 'female') {
      this._gender = newGender;
    }
    else {
      this._gender = 'NULL';
    }
  }

  set weight(int newWeight) {
    if (newWeight <= 1000) {
      this._weight = newWeight;
    }
  }

  set age(int newAge) {
    if (newAge <= 120) {
      this._age = newAge;
    }
  }

  set height(int newHeight) {
    if (newHeight <= 300) {
      this._height = newHeight;
    }
  }

  toJson()
  {
    return {
      "username" : _username,
      "gender"   : _gender,
      "weight"   : _weight,
      "age"      : _age,
      "height"   : _height
    };
  }

  User.fromMapObject(Map<String, dynamic> myMap) {
    this._username = myMap['username'];
    this._gender = myMap['gender'];
    this._weight = myMap['weight'];
    this._age = myMap['age'];
    this._height = myMap['height'];
  }//User.fromMapObjects

  Map<String, dynamic> toMap() {

    //empty map object
    var myMap = Map<String, dynamic>();

    myMap['username'] = _username;
    myMap['gender'] = _gender;
    myMap['weight'] = _weight;
    myMap['age'] = _age;
    myMap['height'] = _height;

    return myMap;
  }// toMap()

}