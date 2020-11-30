import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:archive_your_bill/model/hParameter.dart';

//TO-DO: Last day, week, 
//https://stackoverflow.com/questions/61949626/flutter-filter-list-based-on-last-week-last-month-and-last-year
//https://google.github.io/charts/flutter/example/axes/custom_axis_tick_formatters.html
//https://stackoverflow.com/questions/61356125/how-do-i-set-min-and-max-value-of-the-range-in-flutter-chart

class HParameterNotifier with ChangeNotifier {
  List<Hparameter> _hParameterList = [];
  Hparameter _currentHParameter;

  UnmodifiableListView<Hparameter> get hParameterList => UnmodifiableListView(_hParameterList);

  Hparameter get currentHParameter => _currentHParameter;

  set hParameterList(List<Hparameter> hParameterList) {
    _hParameterList = hParameterList;
    notifyListeners();
  }

  set currentHParameter(Hparameter hParameter) {
    _currentHParameter = hParameter;
    notifyListeners();
  }

  addBill(Hparameter hParameter) {
    _hParameterList.insert(0, hParameter);
    notifyListeners();
  }

  deleteBill(Hparameter hParameter) {
    _hParameterList.removeWhere((_bill) => _bill.id == hParameter.id);
    notifyListeners();
  }
}