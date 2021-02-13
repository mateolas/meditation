import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:take_a_breath/model/hParameter.dart';

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