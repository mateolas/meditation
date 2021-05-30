import 'package:flutter/cupertino.dart';
import 'package:take_a_breath/model/meditationSession.dart';
import 'dart:collection';

class MeditationSessionNotifier with ChangeNotifier {
  List<MeditationSession> _meditationSessionList = [];
  int _lengthOfCurrentSession;
  //setting default sound name when starting the app
  String _soundName = 'medium_bell.mp3';
  DateTime _selectedDay;

  //to get meditationSessionList
  UnmodifiableListView<MeditationSession> get meditationSessionList =>
      UnmodifiableListView(_meditationSessionList);
  //to get length of current session
  int get getLengthOfCurrentSession => _lengthOfCurrentSession;
  //to get setted sound name
  String get getSoundName => _soundName;
  //to get which day is currently set in chart view
  DateTime get getSelectedDay => _selectedDay;

  set meditationSessionList(List<MeditationSession> meditationSessionList) {
    _meditationSessionList = meditationSessionList;
    notifyListeners();
  }

  addMeditationSession(MeditationSession meditationSession) {
    _meditationSessionList.insert(0, meditationSession);
    notifyListeners();
  }

  void setLengthOfCurrentSession(int value) {
    _lengthOfCurrentSession = value;
    notifyListeners();
  }

  void setSoundName(String soundName) {
    _soundName = soundName;
    notifyListeners();
  }

  setSelectedDay(DateTime selectedDay) {
    _selectedDay = selectedDay;
  }
}
