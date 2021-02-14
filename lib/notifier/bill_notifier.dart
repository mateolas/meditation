import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:take_a_breath/model/meditationSession.dart';

class HParameterNotifier with ChangeNotifier {
  List<MeditationSession> _hParameterList = [];
  MeditationSession _currentHParameter;

  UnmodifiableListView<MeditationSession> get hParameterList => UnmodifiableListView(_hParameterList);

  MeditationSession get currentHParameter => _currentHParameter;

  set hParameterList(List<MeditationSession> hParameterList) {
    _hParameterList = hParameterList;
    notifyListeners();
  }

  set currentHParameter(MeditationSession hParameter) {
    _currentHParameter = hParameter;
    notifyListeners();
  }

  addBill(MeditationSession hParameter) {
    _hParameterList.insert(0, hParameter);
    notifyListeners();
  }

  deleteBill(MeditationSession hParameter) {
    _hParameterList.removeWhere((_bill) => _bill.id == hParameter.id);
    notifyListeners();
  }
}