import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:take_a_breath/model/meditationSession.dart';

class UnitsNotifier with ChangeNotifier {
  bool _isCelsius = true;
  bool _isFahrenheit = false;
  bool _isKilograms = true;
  bool _isPounds = false;

  get getIsCelsius => _isCelsius;
  get getIsFahrenheit => _isFahrenheit;

  get getIsKilogram => _isKilograms;
  get getIsPound => _isPounds;

  void setTemperatureUnitToCelsius() {
    _isCelsius = true;
    _isFahrenheit = false;
    notifyListeners();
  }

  void setTemperatureUnitToFahrenheit() {
    _isFahrenheit = true;
    _isCelsius = false;
    notifyListeners();
  }

  void setWeightUnitToKilograms() {
    _isKilograms = true;
    _isPounds = false;
    notifyListeners();
  }

  void setWeightUnitToPounds() {
    _isKilograms = false;
    _isPounds = true;
    notifyListeners();
  }
}
