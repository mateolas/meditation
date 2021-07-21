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
  //to store selected year in charts
  DateTime _selectedYear;
  //total time spent week/month/year
  int _totalTimeSpent;
  //average time spent week/month/year
  int _averageTimeSpent;
  //longest session spent week/month/year
  int _longestTimeSpent;
  //number of sessions per week/month/year
  int _numberOfSessions;
  //to get the current page
  String _selectedPage = 'Home';

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
  //to get from which date starts a new week in chart view
  DateTime get getSelectedYear => _selectedYear;
  //to get total time spent per per week/month/year
  int get getTotalTimeSpent => _totalTimeSpent;
  //to get average time spent per per week/month/year
  int get getAverageTimeSpent => _averageTimeSpent;
  //to get longest time spent per per week/month/year
  int get getLongestTimeSpent => _longestTimeSpent;
  //to get longest time spent per per week/month/year
  int get getNumberOfSessions => _numberOfSessions;
  //to get longest time spent per per week/month/year
  String get getSelectedPage => _selectedPage;

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

  setSelectedYear(DateTime selectedYear) {
    _selectedYear = selectedYear;
  }

  setTotalTimeSpent(int totalTimeSpent) {
    _totalTimeSpent = totalTimeSpent;
  }

  setAverageTimeSpent(int averageTimeSpent) {
    _averageTimeSpent = averageTimeSpent;
  }

  setLongestTimeSpent(int longestTimeSpent) {
    _longestTimeSpent = longestTimeSpent;
  }

  setNumberOfSessions(int numberOfSessions) {
    _numberOfSessions = numberOfSessions;
  }

  setSelectedPage(String selectedPage) {
    _selectedPage = selectedPage;
  }
}
