void main() {
  List<bool> myBoolList = [true, false, true, false, true, false, true, false];

  print('myBoolList: $myBoolList');
  print(sortBoolList(myBoolList, true));
  print(sortBoolList(myBoolList, false));
}

// function sorting bool list with isTrueFirst parameter
List<bool> sortBoolList(List<bool> boolList, bool isTrueFirst) {
  List<bool> sortedBoolList = [];
  List<bool> trueList = [];
  List<bool> falseList = [];

  for (bool boolItem in boolList) {
    if (boolItem) {
      trueList.add(boolItem);
    } else {
      falseList.add(boolItem);
    }
  }

  if (isTrueFirst) {
    sortedBoolList = trueList + falseList;
  } else {
    sortedBoolList = falseList + trueList;
  }

  return sortedBoolList;
}
