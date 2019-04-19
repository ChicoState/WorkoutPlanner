class Goal
{
  String goalName;
  String goalDescription;
  int goalCompleted; // 0 = goal should be in the active tab, 1 = goal should be in the completed tab

  Goal({this.goalName, this.goalDescription, this.goalCompleted});

  setProperties(String name, String desc, int comp)
  {
    goalName = name;
    goalDescription = desc;
    goalCompleted = comp;
  }

  toJson()
  {
    return {
      "name" : goalName,
      "description" : goalDescription,
      "completed" : goalCompleted
    };
  }

}