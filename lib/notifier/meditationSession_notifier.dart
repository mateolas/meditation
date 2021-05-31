import 'package:flutter/cupertino.dart';
import 'package:take_a_breath/model/meditationSession.dart';
import 'dart:collection';

class MeditationSessionNotifier with ChangeNotifier {
  List<MeditationSession> _meditationSessionList = [];
  int _lengthOfCurrentSession;
  //setting default sound name when starting the app
  String _soundName = 'medium_bell.mp3';
  //to store selected day in charts
  DateTime _selectedDay;
  //to store selected week start day in charts
  DateTime _selectedWeekStartDay;
  //to store selected week end day in charts
  DateTime _selectedWeekEndDay;
  //to store selected month in charts
  DateTime _selectedMonth;

  //to get meditationSessionList
  UnmodifiableListView<MeditationSession> get meditationSessionList =>
      UnmodifiableListView(_meditationSessionList);
  //to get length of current session
  int get getLengthOfCurrentSession => _lengthOfCurrentSession;
  //to get setted sound name
  String get getSoundName => _soundName;
  //to get which day is currently set in chart view
  DateTime get getSelectedDay => _selectedDay;
  //to get from which date starts a new week in chart view
  DateTime get getSelectedWeekStartDay => _selectedWeekStartDay;
  //to get from which date starts a new week in chart view
  DateTime get getSelectedWeekEndDay => _selectedWeekEndDay;
  //to get from which date starts a new week in chart view
  DateTime get getSelectedMonth => _selectedMonth;

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

  setSelectedWeekStartDay(DateTime selectedWeekStartDay) {
    _selectedWeekStartDay = selectedWeekStartDay;
  }

  setSelectedWeekEndDay(DateTime selectedWeekEndDay) {
    _selectedWeekEndDay = selectedWeekEndDay;
  }

  setSelectedMOnth(DateTime selectedMonth) {
    _selectedMonth = selectedMonth;
  }
}
