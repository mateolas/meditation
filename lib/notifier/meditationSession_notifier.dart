import 'package:flutter/cupertino.dart';

class MeditationSessionNotifier with ChangeNotifier {
  int _lengthOfCurrentSession;

  int get getLengthOfCurrentSession => _lengthOfCurrentSession;

  void setLengthOfCurrentSession(int value) {
    _lengthOfCurrentSession = value;
    notifyListeners();
  }
}
