import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:workout_planner/models/User.dart';

class DBhelper {

  //singleton pattern
  static DBhelper _dbHelper;
  static Database _database;

  //named constructor, only called when named

  //used to initialize dbHelper object.
  DBhelper._createDB();

  //constructor
  factory DBhelper() {

    //only create _db if its null
    if(_dbHelper == null) {
      _dbHelper = DBhelper._createDB();
    }
    return _dbHelper;
  } //DBhelper

  /*
  returns the database unless it doesn't exist.
   */
  Future<Database> get database async {
    //return database if it exists
    //else it will create it.
    if (_database == null) {
      _database = await initDB();
    }
    return _database;
  }
  /*
  Finds the absolute path to Android's db folder and uses that path to
  create the 'myTrainer.db' file and store it there.
   */
  Future<Database> initDB() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'myTrainer.db');
    
    Database _db = await openDatabase(path, version: 1, onCreate: _createDB);
    return _db;
  }
  /*
  Creates the entire myTrainer DB
   */
  void _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE initial_table ('
        'id INTEGER PRIMARY KEY,'
        'username TEXT,'
        'gender TEXT,'
        'weight INTEGER,'
        'age INTEGER,'
        'height INTEGER)');
  }
  //====================================================================
  //CRUD Operations == create, read, update, delete
  /*
  returns Table as a List type.
   */
  Future<List<Map<String, dynamic>>> getMapList(String tableName, var colOrder)
  async {
    Database db = await this.database;

    var result = await db.query(tableName, orderBy: colOrder);

    return result;
  }//getMapList

  /*
  name: insertToTable
  para: tableObj, tableName
  return: Future<int>
  desc: Takes in a table object and a tableName type string and checks if table
  exists in the database. If it exists then a new row is added, returns a 1 or 0

   */
  Future<int> insertToTable(var tableObj, String tableName) async {
    Database db = await this.database;

    //checks if table exists, if it does then it inserts a row onto the table.
    bool doesTableExist = await _lookupTable(tableName);
    if(doesTableExist) {
      var result = await db.insert(
          tableName, tableObj.toMap()); //returns an int.
      return result;
    }
    return 0;
  }

  /*
  name: updateToTable
  para: tableObj, tableName, colID, id
  return: Future<int>
  desc: Function takes in 4 parameters. colName is the column name and id is the
  key in the where clause. The row is updated
   */
  Future<int> updateToTable(var tableObj, String tableName, var colName, var id)
  async {
    Database db = await this.database;

    colName = tableObj.id;
    bool doesTableExist = await _lookupTable(tableName);
    if(doesTableExist) {
      //update based on id
      //UPDATE tableName SET colID = id;
      var result = await db.update(tableName, tableObj.toMap(),
          where: '$colName = ?', whereArgs: [id]);
      return result;
    }

    return 0;
  }

  /*
  name: deleteFromTable
  para: tableObj, tableName, colName, id
  return: Future<int>
  desc: function takes in a model and name of the table and looks to see if it
  exists. If it exists then it deletes the value using id in the column using
  colName.
   */
  Future<int> deleteFromTable(var tableObj, String tableName, var colName, int id)
  async {
    Database db = await this.database;

    bool doesTableExist = await _lookupTable(tableName);
    if(doesTableExist) {
      //DELETE FROM tableName WHERE colName = id;
      var result = await db.delete(tableName, where: '$colName = ?',
          whereArgs: [id]);
          return result;
    }
    return 0;
  }
  /*
  name: getCount
  para: tableName

   */
  Future<int> getCount(String tableName) async {
    Database db = await this.database;

    //Counts all in 'tableName' and stores it in another table with 1 row.
    bool doesTableExist = await _lookupTable(tableName);
    if(doesTableExist){
      List<Map<String, dynamic>> countTable = await db.rawQuery(
          'SELECT COUNT (*)'
              'FROM $tableName');

      var result = Sqflite.firstIntValue(countTable);
      return result;
    }
    return 0;
  }
  // CRUD OPERATIONS ==========================================================

  Future<bool> _lookupTable(String tableName) async {
    Database db = await this.database;

    var result = await db.rawQuery('SELECT name FROM sqlite_master '
        'WHERE type="table"'
        'AND name = "$tableName"');
    //table exists
    if (result.length == 1) {
      return true;
    }
    else {
      return false;
    }
  }//lookUpTable

  Future<User> getUser(int id) async {
    Database db = await this.database;

    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM initial_table WHERE id = $id'
    );

    User user = User.fromMapObject(result[0]);
    return user;
  }

  /*
  this function DELETES THE DATABASE!!!
  DO NOT RUN THIS UNLESS YOU NEED TO.
   */
  void _deleteDB() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'myTrainer.db');
    await deleteDatabase(path);
  }

}//DBhelper