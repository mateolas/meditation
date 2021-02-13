import 'package:flutter/cupertino.dart';

class MeditationSessionNotifier with ChangeNotifier {
  int _lengthOfCurrentSession;
  String _soundName = 'medium_bell.mp3';

  int get getLengthOfCurrentSession => _lengthOfCurrentSession;
  String get getSoundName => _soundName;


  void setLengthOfCurrentSession(int value) {
    _lengthOfCurrentSession = value;
    notifyListeners();
  }

  void setSoundName(String soundName) {
    _soundName = soundName;
    notifyListeners();
  }
}
