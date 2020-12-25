import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:health_parameters_tracker/model/hParameter.dart';

class UnitsNotifier with ChangeNotifier {
  bool _isCelsius;
  bool _isFahrenheit;

  get getIsCelsius => _isCelsius;
  get getIsFahrenheit => _isFahrenheit;

  void setTemperatureUnitToCelsius(bool isCelsius) {
    _isCelsius = isCelsius;
    _isFahrenheit = false;
    notifyListeners();
  }

  void setTemperatureUnitToFahrenheit(bool isFahrenheit) {
    _isFahrenheit = isFahrenheit;
    _isCelsius = false;
    notifyListeners();
  }
}
