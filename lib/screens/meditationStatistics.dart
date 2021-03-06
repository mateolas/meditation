import 'package:flutter/material.dart';
import 'package:take_a_breath/model/colors.dart';
import 'package:provider/provider.dart';
import 'package:take_a_breath/widgets/meditationSessionsChartDay.dart';
import 'package:take_a_breath/widgets/meditationSessionsChartWeek.dart';
import 'package:take_a_breath/widgets/meditationSessionsChartMonth.dart';
import 'package:take_a_breath/widgets/meditationSessionsChartYear.dart';
import 'package:take_a_breath/api/meditationSession_api.dart';
import 'package:take_a_breath/notifier/meditationSession_notifier.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class MeditationStatistics extends StatefulWidget {
  @override
  _MeditationStatisticsState createState() => _MeditationStatisticsState();
}

class _MeditationStatisticsState extends State<MeditationStatistics>
    with SingleTickerProviderStateMixin {
  //what time frame was selected: Day/Week/Month/Year/All
  String selectedTimeFrame;

  //list to hold names of the options for time frame
  List timeFrameViewList = [
    'DAY',
    'WEEK',
    'MONTH',
    'YEAR',
  ];

  //time frame time controller
  TabController _timeFrameViewController;

  //boolean to show/hide ">" from the date selection
  bool isIncreaseSignNeedToVisible;

  //date to present currently "active" date
  DateTime currentDateDay;
  //date to present first day of the week (based on provided date)
  DateTime currentDateStartOfTheWeek;
  DateTime initCurrentDateStartOfTheWeek;
  //date to present last day of the week (based on provided date)
  DateTime currentDateEndOfTheWeek;
  //date to present currently "active" month
  DateTime currentMonth = DateTime.now();
  //date to present currently "active" month
  DateTime currentYear;

  //reference date (to disable increasing year/month, week,day after current one)
  final DateTime initCurrentDate = DateTime.now();
  DateTime initCurrentDateEndOfTheWeek;

  int weekCounter;

  @override
  void initState() {
    super.initState();
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);

    //fetching data from firebase
    getMeditationSession(meditationSessionNotifier);

    //setting default time frame view for 'Day'
    selectedTimeFrame = 'DAY';

    _timeFrameViewController = new TabController(vsync: this, length: 4);

    //screen starting from presenting "today"
    currentDateDay = DateTime.now();

    //screen starting from presenting "today"
    currentMonth = DateTime.now();

    //screen starting from presenting "today"
    currentYear = DateTime.now();

    //setting to provider current day
    meditationSessionNotifier.setSelectedDay(currentDateDay);

    //setting to provider current year
    meditationSessionNotifier.setSelectedYear(currentYear);

    //setting to provider current month
    meditationSessionNotifier.setSelectedMOnth(currentMonth);

    initCurrentDateStartOfTheWeek = findFirstDateOfTheWeek(currentDateDay);
    //setting to provider current day
    meditationSessionNotifier
        .setSelectedWeekStartDay(initCurrentDateStartOfTheWeek);

    initCurrentDateEndOfTheWeek = findLastDateOfTheWeek(currentDateDay);
    //setting to provider current day
    meditationSessionNotifier
        .setSelectedWeekEndDay(initCurrentDateEndOfTheWeek);

    currentDateEndOfTheWeek = initCurrentDateEndOfTheWeek;
    currentDateStartOfTheWeek = initCurrentDateStartOfTheWeek;

    //TO - DO - ">" sign to dissapear while on current date
    //on welcome screen we're starting from the actual day
    //so we need to hide ">" from presented day
    //isIncreaseSignNeedToVisible = false;

    weekCounter = 7;
  }

  // Find the first day of the week which contains the provided date.
  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    isIncreaseSignNeedToVisible = false;
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  //Find last day of the week which contains provided date.
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    isIncreaseSignNeedToVisible = false;
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  /// Find first date of previous week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findFirstDateOfPreviousWeek(DateTime dateTime, int k) {
    isIncreaseSignNeedToVisible = true;
    final DateTime sameWeekDayOfLastWeek = dateTime.subtract(Duration(days: k));
    return findFirstDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  /// Find last date of previous week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findLastDateOfPreviousWeek(DateTime dateTime, int k) {
    isIncreaseSignNeedToVisible = true;
    final DateTime sameWeekDayOfLastWeek = dateTime.subtract(Duration(days: k));
    return findLastDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  /// Find first date of previous week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findFirstDateOfNextWeek(DateTime dateTime, int k) {
    isIncreaseSignNeedToVisible = true;
    final DateTime sameWeekDayOfLastWeek = dateTime.add(Duration(days: k));
    return findFirstDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  /// Find last date of previous week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findLastDateOfNextWeek(DateTime dateTime, int k) {
    isIncreaseSignNeedToVisible = true;
    final DateTime sameWeekDayOfLastWeek = dateTime.add(Duration(days: k));
    return findLastDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  //function to decrease the presented date based on chosen time frame
  DateTime decreaseDatePerDay(DateTime time, String typeOfTimeFrame) {
    //instance of MeditationSessionNotifier to set current date to current day provider
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);
    int timeFrameValue;
    if (typeOfTimeFrame == 'DAY') {
      timeFrameValue = 1;
      setState(() {
        currentDateDay =
            DateTime(time.year, time.month, time.day - timeFrameValue);
        //set current day to provider
        meditationSessionNotifier.setSelectedDay(currentDateDay);
        isIncreaseSignNeedToVisible = true;
      });
    }
    return currentDateDay;
  }

  //function to decrease the presented date based on chosen time frame
  DateTime increaseDatePerDay(DateTime time, String typeOfTimeFrame) {
    //instance of MeditationSessionNotifier to set current date to current day provider
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);
    int timeFrameValue = 1;
    if (typeOfTimeFrame == 'DAY') {
      timeFrameValue = 1;
      //value to compare currentDate
      DateTime actualDay = DateTime.now();
      if (DateTime(
              currentDateDay.year, currentDateDay.month, currentDateDay.day)
          .isAtSameMomentAs(
              DateTime(actualDay.year, actualDay.month, actualDay.day))) {
        setState(() {
          isIncreaseSignNeedToVisible = false;
          //set current day to provider
          meditationSessionNotifier.setSelectedDay(currentDateDay);
        });
      }
      if (DateTime(
              currentDateDay.year, currentDateDay.month, currentDateDay.day)
          .isBefore(DateTime(actualDay.year, actualDay.month, actualDay.day))) {
        setState(() {
          currentDateDay =
              DateTime(time.year, time.month, time.day + timeFrameValue);
          //set current day to provider
          meditationSessionNotifier.setSelectedDay(currentDateDay);
        });
      }
    }

    return currentDateDay;
  }

  //function to decrease the presented date based on chosen time frame
  DateTime decreaseDatePerWeek() {
    //instance of MeditationSessionNotifier to set current week start/end day to provider
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);
    DateTime time = DateTime.now();

    setState(() {
      currentDateStartOfTheWeek = DateTime(currentDateStartOfTheWeek.year,
          currentDateStartOfTheWeek.month, currentDateStartOfTheWeek.day - 7);
      findFirstDateOfPreviousWeek(time, weekCounter);

      //set selected week start day to provider
      meditationSessionNotifier
          .setSelectedWeekStartDay(currentDateStartOfTheWeek);

      currentDateEndOfTheWeek = DateTime(currentDateEndOfTheWeek.year,
          currentDateEndOfTheWeek.month, currentDateEndOfTheWeek.day - 7);
      //set selected week start end to provider
      meditationSessionNotifier.setSelectedWeekEndDay(currentDateEndOfTheWeek);

      weekCounter = weekCounter + 7;
    });

    return currentDateDay;
  }

  //function to decrease the presented date based on chosen time frame
  DateTime increaseDatePerWeek() {
    //instance of MeditationSessionNotifier to set current week start/end day to provider
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);

    if (currentDateStartOfTheWeek.day == initCurrentDateStartOfTheWeek.day) {
    } else
      setState(() {
        currentDateStartOfTheWeek = DateTime(currentDateStartOfTheWeek.year,
            currentDateStartOfTheWeek.month, currentDateStartOfTheWeek.day + 7);
        //set selected week start day to provider
        meditationSessionNotifier
            .setSelectedWeekStartDay(currentDateStartOfTheWeek);

        currentDateEndOfTheWeek = DateTime(currentDateEndOfTheWeek.year,
            currentDateEndOfTheWeek.month, currentDateEndOfTheWeek.day + 7);
        //set selected week start end to provider
        meditationSessionNotifier
            .setSelectedWeekEndDay(currentDateEndOfTheWeek);

        weekCounter = weekCounter + 7;
      });

    return currentDateDay;
  }

  //function to decrease the presented date based on chosen time frame
  DateTime decreaseDatePerMonth(DateTime time, String typeOfTimeFrame) {
    //instance of MeditationSessionNotifier to set current month to provider
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);
    int timeFrameValue;
    if (typeOfTimeFrame == 'MONTH') {
      timeFrameValue = 1;
      setState(() {
        currentMonth =
            DateTime(time.year, time.month - timeFrameValue, time.day);
        isIncreaseSignNeedToVisible = true;
        meditationSessionNotifier.setSelectedMOnth(currentMonth);
      });
    }
    return currentMonth;
  }

  //function to decrease the presented date based on chosen time frame
  DateTime increaseDatePerMonth(DateTime time, String typeOfTimeFrame) {
    //instance of MeditationSessionNotifier to set current month to provider
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);
    int timeFrameValue;
    if (time.month == initCurrentDate.month) {
    } else {
      timeFrameValue = 1;
      setState(() {
        currentMonth =
            DateTime(time.year, time.month + timeFrameValue, time.day);
        meditationSessionNotifier.setSelectedMOnth(currentMonth);
      });
    }
    return currentMonth;
  }

  //function to decrease the presented date based on chosen time frame
  DateTime decreaseDatePerYear(DateTime time, String typeOfTimeFrame) {
    //instance of MeditationSessionNotifier to set current year to provider
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);
    int timeFrameValue;
    if (typeOfTimeFrame == 'YEAR') {
      timeFrameValue = 1;
      setState(() {
        currentYear =
            DateTime(time.year - timeFrameValue, time.month, time.day);
        isIncreaseSignNeedToVisible = true;
        meditationSessionNotifier.setSelectedYear(currentYear);
      });
    }
    return currentYear;
  }

  //function to decrease the presented date based on chosen time frame
  DateTime increaseDatePerYear(DateTime time, String typeOfTimeFrame) {
    //instance of MeditationSessionNotifier to set current year to provider
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);
    int timeFrameValue;
    if (typeOfTimeFrame == 'YEAR') {
      timeFrameValue = 1;
      if (time.year == initCurrentDate.year) {
      } else {
        setState(() {
          currentYear = DateTime(time.year + timeFrameValue);
          meditationSessionNotifier.setSelectedYear(currentYear);
        });
      }
    }
    return currentYear;
  }

  //widget to present date based on chosen time frame
  Widget whatDateToPresent(String selectedTimeFrame) {
    //instance of MeditationSessionNotifier to get selected month
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);

    Text whatDateToPresent;
    if (selectedTimeFrame == "DAY") {
      whatDateToPresent = Text('${DateFormat.yMMMd().format(currentDateDay)}');
      meditationSessionNotifier.setSelectedDay(currentDateDay);
    }

    if (selectedTimeFrame == "WEEK") {
      currentDateDay = DateTime.now();
      whatDateToPresent = Text(
          '${DateFormat.yMMMd().format(currentDateStartOfTheWeek)} - ${DateFormat.yMMMd().format(currentDateEndOfTheWeek)}');
    }

    if (selectedTimeFrame == "MONTH") {
      whatDateToPresent = Text('${DateFormat.yMMM().format(currentMonth)}');
      meditationSessionNotifier.setSelectedMOnth(currentMonth);
    }

    if (selectedTimeFrame == "YEAR") {
      whatDateToPresent = Text('${DateFormat.y().format(currentYear)}');
      meditationSessionNotifier.setSelectedYear(currentYear);
    }

    return whatDateToPresent;
  }

  //widghet to present chart based on chosen time frame
  Widget whatChartToPresent(String selectedTimeFrame) {
    var whatChartToPresent;
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);

    if (selectedTimeFrame == "DAY") {
      whatChartToPresent = MeditationSessionsChartDay.withSampleData(
          meditationSessionNotifier,
          currentDateDay,
          currentDateStartOfTheWeek,
          currentDateEndOfTheWeek,
          selectedTimeFrame);
    }

    if (selectedTimeFrame == "WEEK") {
      whatChartToPresent = MeditationSessionsChartWeek.withSampleData(
          meditationSessionNotifier,
          currentDateDay,
          currentDateStartOfTheWeek,
          currentDateEndOfTheWeek,
          selectedTimeFrame);
    }

    if (selectedTimeFrame == "MONTH") {
      whatChartToPresent = MeditationSessionsChartMonth.withSampleData(
          meditationSessionNotifier,
          currentDateDay,
          currentMonth,
          currentDateStartOfTheWeek,
          currentDateEndOfTheWeek,
          selectedTimeFrame);
    }

    if (selectedTimeFrame == "YEAR") {
      whatChartToPresent = MeditationSessionsChartYear.withSampleData(
          meditationSessionNotifier,
          currentYear,
          currentDateStartOfTheWeek,
          currentDateEndOfTheWeek,
          selectedTimeFrame);
    }

    return whatChartToPresent;
  }

  //widget to present daily statistics
  Widget dailyStatistics(int sessionLength) {
    double mainTimeFontSize = 24;
    double titleFontSize = 13;
    double spaceBetweenRowsSize = 48;
    Color mainTextTimeColor = Colors.orange;
    Color titleTextColor = Colors.black;
    Color tableFrameColor = Colors.black;

    //instance of MeditationSessionNotifier to get statistics from provider
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);

    //draw a table
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(30, 4, 30, 4),
            child: Table(
              border: TableBorder(
                  horizontalInside: BorderSide(
                      width: 1,
                      color: tableFrameColor,
                      style: BorderStyle.solid),
                  verticalInside: BorderSide(
                      width: 1,
                      color: tableFrameColor,
                      style: BorderStyle.solid)),
              children: [
                TableRow(children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),

                      //if number of meditation sessions is 0 present "-"
                      meditationSessionNotifier.getLongestTimeSpent == 0
                          ? Text(
                              "-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getNumberOfSessions}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Number of sessions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                      //if meditation session average length is 0 present "-"
                      meditationSessionNotifier.getTotalTimeSpent == 0
                          ? Text(
                              " - ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getTotalTimeSpent} min",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Total time spent',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                      //if meditation session total length is 0 present "-"
                      meditationSessionNotifier.getAverageTimeSpent == 0
                          ? Text(
                              "-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getAverageTimeSpent} min",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Average time spent',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                      //if meditation session longest session is 0 present "-"
                      meditationSessionNotifier.getLongestTimeSpent == 0
                          ? Text(
                              "-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getLongestTimeSpent} min",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Longest session',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ]));
  }

  //widget to present weekly statistics
  Widget weeklyStatistics() {
    double mainTimeFontSize = 24;
    double titleFontSize = 13;
    double spaceBetweenRowsSize = 48;
    Color mainTextTimeColor = Colors.orange;
    Color titleTextColor = Colors.black;
    Color tableFrameColor = Colors.black;

    //instance of MeditationSessionNotifier to get statistics from provider
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);

    //draw a table
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(30, 4, 30, 4),
            child: Table(
              border: TableBorder(
                  horizontalInside: BorderSide(
                      width: 1,
                      color: tableFrameColor,
                      style: BorderStyle.solid),
                  verticalInside: BorderSide(
                      width: 1,
                      color: tableFrameColor,
                      style: BorderStyle.solid)),
              children: [
                TableRow(children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),

                      //if number of meditation sessions is 0 present "-"
                      meditationSessionNotifier.getLongestTimeSpent == 0
                          ? Text(
                              "-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getNumberOfSessions}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Number of sessions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                      //if meditation session average length is 0 present "-"
                      meditationSessionNotifier.getTotalTimeSpent == 0
                          ? Text(
                              " - ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getTotalTimeSpent} min",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Total time spent',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                      //if meditation session total length is 0 present "-"
                      meditationSessionNotifier.getAverageTimeSpent == 0
                          ? Text(
                              "-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getAverageTimeSpent} min",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Average time spent',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                      //if meditation session longest session is 0 present "-"
                      meditationSessionNotifier.getLongestTimeSpent == 0
                          ? Text(
                              "-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getLongestTimeSpent} min",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Longest session',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ]));
  }

  Widget monthlyStatistics() {
    double mainTimeFontSize = 24;
    double titleFontSize = 13;
    double spaceBetweenRowsSize = 48;
    Color mainTextTimeColor = Colors.orange;
    Color titleTextColor = Colors.black;
    Color tableFrameColor = Colors.black;

    //instance of MeditationSessionNotifier to get statistics from provider
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);

    //draw a table
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(30, 4, 30, 4),
            child: Table(
              border: TableBorder(
                  horizontalInside: BorderSide(
                      width: 1,
                      color: tableFrameColor,
                      style: BorderStyle.solid),
                  verticalInside: BorderSide(
                      width: 1,
                      color: tableFrameColor,
                      style: BorderStyle.solid)),
              children: [
                TableRow(children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),

                      //if number of meditation sessions is 0 present "-"
                      meditationSessionNotifier.getLongestTimeSpent == 0
                          ? Text(
                              "-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getNumberOfSessions}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Number of sessions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                      //if meditation session average length is 0 present "-"
                      meditationSessionNotifier.getTotalTimeSpent == 0
                          ? Text(
                              " - ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getTotalTimeSpent} min",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Total time spent',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                      //if meditation session total length is 0 present "-"
                      meditationSessionNotifier.getAverageTimeSpent == 0
                          ? Text(
                              "-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getAverageTimeSpent} min",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Average time spent',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                      //if meditation session longest session is 0 present "-"
                      meditationSessionNotifier.getLongestTimeSpent == 0
                          ? Text(
                              "-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getLongestTimeSpent} min",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Longest session',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ]));
  }

  Widget yearlyStatistics() {
    double mainTimeFontSize = 24;
    double titleFontSize = 13;
    double spaceBetweenRowsSize = 48;
    Color mainTextTimeColor = Colors.orange;
    Color titleTextColor = Colors.black;
    Color tableFrameColor = Colors.black;

    //instance of MeditationSessionNotifier to get statistics from provider
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);

    //draw a table
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(30, 4, 30, 4),
            child: Table(
              border: TableBorder(
                  horizontalInside: BorderSide(
                      width: 1,
                      color: tableFrameColor,
                      style: BorderStyle.solid),
                  verticalInside: BorderSide(
                      width: 1,
                      color: tableFrameColor,
                      style: BorderStyle.solid)),
              children: [
                TableRow(children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),

                      //if number of meditation sessions is 0 present "-"
                      meditationSessionNotifier.getLongestTimeSpent == 0
                          ? Text(
                              "-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getNumberOfSessions}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Number of sessions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                      //if meditation session average length is 0 present "-"
                      meditationSessionNotifier.getTotalTimeSpent == 0
                          ? Text(
                              " - ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getTotalTimeSpent} min",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Total time spent',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                      //if meditation session total length is 0 present "-"
                      meditationSessionNotifier.getAverageTimeSpent == 0
                          ? Text(
                              "-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getAverageTimeSpent} min",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Average time spent',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                      //if meditation session longest session is 0 present "-"
                      meditationSessionNotifier.getLongestTimeSpent == 0
                          ? Text(
                              "-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            )
                          : Text(
                              "${meditationSessionNotifier.getLongestTimeSpent} min",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainTextTimeColor,
                                  fontSize: mainTimeFontSize),
                            ),
                      Text(
                        'Longest session',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: titleTextColor, fontSize: titleFontSize),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            spaceBetweenRowsSize,
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ]));
  }

  //widget to present statistics (below chart) based on chosen time frame
  Widget whatInformationToPresent(String selectedTimeFrame) {
    var whatInformationToPresent;

    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);
    int totalTimePerDay = 0;

    //what widget (below the charts) to present when timeframe is "DAY"
    if (selectedTimeFrame == "DAY") {
      whatInformationToPresent = dailyStatistics(totalTimePerDay);
    }

    //what widget (below the charts) to present when timeframe is "WEEK"
    if (selectedTimeFrame == "WEEK") {
      ///TO - DO
      ///Create a list in provider to store "filtered" list of sessions from
      ///particular list

      whatInformationToPresent = weeklyStatistics();
    }

    if (selectedTimeFrame == "MONTH") {
      whatInformationToPresent = monthlyStatistics();
    }

    if (selectedTimeFrame == "YEAR") {
      whatInformationToPresent = yearlyStatistics();
    }

    return whatInformationToPresent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //container to "imitate" app bar background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xffe65c00),
                  Color(0xffFFE000),
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height / 9,
            width: MediaQuery.of(context).size.width,
          ),
          // tab controller for time frame //
          //tab controller to present "Day/ Week / Month / Year"
          DefaultTabController(
            length: timeFrameViewList.length,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 34),
              child: TabBar(
                labelColor: Colors.black,
                onTap: (index) {
                  setState(() {
                    //set the name of time frame
                    //selectedTimeTempView used as an argument in "draw a chart" function
                    selectedTimeFrame = timeFrameViewList[index];
                  });
                },
                indicatorColor: Colors.orange,
                controller: _timeFrameViewController,
                isScrollable: true,
                labelStyle: TextStyle(
                  fontSize: 12.0,
                ),
                //For Selected tab
                unselectedLabelStyle: TextStyle(
                  fontSize: 12.0,
                ), //For Un-selected Tabs
                //funtion to generate tabs
                tabs: new List.generate(timeFrameViewList.length, (index) {
                  return new Tab(
                    iconMargin: EdgeInsets.only(bottom: 3),
                    text: timeFrameViewList[index].toUpperCase(),
                  );
                }),
              ),
            ),
          ),
          //row to present the day/week/month/year time frame
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  child: Text(
                    '<   ',
                    style: TextStyle(
                        color: Colors.orange,
                        //fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  onTap: () {
                    if (selectedTimeFrame == 'DAY') {
                      decreaseDatePerDay(currentDateDay, selectedTimeFrame);
                    }
                    if (selectedTimeFrame == 'WEEK') {
                      decreaseDatePerWeek();
                    }
                    if (selectedTimeFrame == 'MONTH') {
                      decreaseDatePerMonth(currentMonth, selectedTimeFrame);
                    }
                    if (selectedTimeFrame == 'YEAR') {
                      decreaseDatePerYear(currentYear, selectedTimeFrame);
                    }
                  }),
              whatDateToPresent(selectedTimeFrame),
              GestureDetector(
                child: Visibility(
                  visible: true, //isIncreaseSignNeedToVisible,
                  child: Text(
                    '   >',
                    style: TextStyle(color: Colors.orange, fontSize: 18),
                  ),
                ),
                onTap: () {
                  if (selectedTimeFrame == 'DAY') {
                    increaseDatePerDay(currentDateDay, selectedTimeFrame);
                  }
                  if (selectedTimeFrame == 'WEEK') {
                    increaseDatePerWeek();
                  }
                  if (selectedTimeFrame == 'MONTH') {
                    increaseDatePerMonth(currentMonth, selectedTimeFrame);
                  }
                  if (selectedTimeFrame == 'YEAR') {
                    increaseDatePerYear(currentYear, selectedTimeFrame);
                  }
                },
              ),
            ],
          ),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                child: whatChartToPresent(selectedTimeFrame),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                child: whatInformationToPresent(selectedTimeFrame),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
