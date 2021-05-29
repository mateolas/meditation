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
    currentDate = DateTime.now();

    currentDateStartOfTheWeek = findFirstDateOfTheWeek(currentDate);
    currentDateEndOfTheWeek = findLastDateOfTheWeek(currentDate);
    //on welcome screen we're starting from the actual day
    //so we need to hide ">" from presented day
    isIncreaseSignNeedToVisible = false;

    weekCounter = 7;
  }

  //date to present currently "active" date
  DateTime currentDate;
  //date to present first day of the week (based on provided date)
  DateTime currentDateStartOfTheWeek;
  //date to present last day of the week (based on provided date)
  DateTime currentDateEndOfTheWeek;

  int weekCounter;

  // Find the first date of the week which contains the provided date.
  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    isIncreaseSignNeedToVisible = false;
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  //Find last date of the week which contains provided date.
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
    int timeFrameValue;
    if (typeOfTimeFrame == 'DAY') {
      timeFrameValue = 1;
      setState(() {
        currentDate =
            DateTime(time.year, time.month, time.day - timeFrameValue);
        isIncreaseSignNeedToVisible = true;
      });
    }
    return currentDate;
  }

  //function to decrease the presented date based on chosen time frame
  DateTime increaseDatePerDay(DateTime time, String typeOfTimeFrame) {
    int timeFrameValue = 1;
    if (typeOfTimeFrame == 'DAY') {
      timeFrameValue = 1;
      //value to compare currentDate
      DateTime currentDay = DateTime.now();
      if (DateTime(currentDate.year, currentDate.month, currentDate.day)
          .isAtSameMomentAs(
              DateTime(currentDay.year, currentDay.month, currentDay.day))) {
        setState(() {
          isIncreaseSignNeedToVisible = false;
        });
      }
      if (DateTime(currentDate.year, currentDate.month, currentDate.day)
          .isBefore(
              DateTime(currentDay.year, currentDay.month, currentDay.day))) {
        setState(() {
          currentDate =
              DateTime(time.year, time.month, time.day + timeFrameValue);
        });
      }
    }

    return currentDate;
  }

  //function to decrease the presented date based on chosen time frame
  DateTime decreaseDatePerWeek() {
    DateTime time = DateTime.now();

    setState(() {
      currentDateStartOfTheWeek =
          findFirstDateOfPreviousWeek(time, weekCounter);
      currentDateEndOfTheWeek = findLastDateOfPreviousWeek(time, weekCounter);
      weekCounter = weekCounter + 7;
    });

    return currentDate;
  }

  //function to decrease the presented date based on chosen time frame
  DateTime increaseDatePerWeek() {
    DateTime time = DateTime.now();

    setState(() {
      currentDateStartOfTheWeek =
          findFirstDateOfPreviousWeek(time, weekCounter);
      currentDateEndOfTheWeek = findLastDateOfPreviousWeek(time, weekCounter);
      weekCounter = weekCounter - 7;
    });

    return currentDate;
  }

  //function to decrease the presented date based on chosen time frame
  DateTime decreaseDatePerMonth(DateTime time, String typeOfTimeFrame) {
    int timeFrameValue;
    if (typeOfTimeFrame == 'MONTH') {
      timeFrameValue = 1;
      setState(() {
        currentDate =
            DateTime(time.year, time.month - timeFrameValue, time.day);
        isIncreaseSignNeedToVisible = true;
      });
    }
    return currentDate;
  }

  //function to decrease the presented date based on chosen time frame
  DateTime increaseDatePerMonth(DateTime time, String typeOfTimeFrame) {
    int timeFrameValue;
    if (typeOfTimeFrame == 'MONTH') {
      timeFrameValue = 1;
      setState(() {
        currentDate =
            DateTime(time.year, time.month + timeFrameValue, time.day);
        isIncreaseSignNeedToVisible = true;
      });
    }
    return currentDate;
  }

  //function to decrease the presented date based on chosen time frame
  DateTime decreaseDatePerYear(DateTime time, String typeOfTimeFrame) {
    int timeFrameValue;
    if (typeOfTimeFrame == 'YEAR') {
      timeFrameValue = 1;
      setState(() {
        currentDate =
            DateTime(time.year - timeFrameValue, time.month, time.day);
        isIncreaseSignNeedToVisible = true;
      });
    }
    return currentDate;
  }

  //function to decrease the presented date based on chosen time frame
  DateTime increaseDatePerYear(DateTime time, String typeOfTimeFrame) {
    int timeFrameValue;
    if (typeOfTimeFrame == 'YEAR') {
      timeFrameValue = 1;
      setState(() {
        currentDate =
            DateTime(time.year + timeFrameValue, time.month, time.day);
        isIncreaseSignNeedToVisible = true;
      });
    }
    return currentDate;
  }

  Widget whatDateToPresent(String selectedTimeFrame) {
    Text whatDateToPresent;
    if (selectedTimeFrame == "DAY") {
      whatDateToPresent = Text('${DateFormat.yMMMd().format(currentDate)}');
    }

    if (selectedTimeFrame == "WEEK") {
      whatDateToPresent = Text(
          '${DateFormat.yMMMd().format(currentDateStartOfTheWeek)} - ${DateFormat.yMMMd().format(currentDateEndOfTheWeek)}');
    }

    if (selectedTimeFrame == "MONTH") {
      whatDateToPresent = Text('${DateFormat.MMM().format(currentDate)}');
    }

    if (selectedTimeFrame == "YEAR") {
      whatDateToPresent = Text('${DateFormat.y().format(currentDate)}');
    }

    return whatDateToPresent;
  }

  Widget whatChartToPresent(String selectedTimeFrame) {
    var whatChartToPresent;
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);

    if (selectedTimeFrame == "DAY") {
      whatChartToPresent = MeditationSessionsChartDay.withSampleData(
          meditationSessionNotifier,
          currentDate,
          currentDateStartOfTheWeek,
          currentDateEndOfTheWeek,
          selectedTimeFrame);
    }

    if (selectedTimeFrame == "WEEK") {
      whatChartToPresent = MeditationSessionsChartWeek.withSampleData(
          meditationSessionNotifier,
          currentDate,
          currentDateStartOfTheWeek,
          currentDateEndOfTheWeek,
          selectedTimeFrame);
    }

    if (selectedTimeFrame == "MONTH") {
      whatChartToPresent = MeditationSessionsChartMonth.withSampleData(
          meditationSessionNotifier,
          currentDate,
          currentDateStartOfTheWeek,
          currentDateEndOfTheWeek,
          selectedTimeFrame);
    }

    if (selectedTimeFrame == "YEAR") {
      whatChartToPresent = MeditationSessionsChartYear.withSampleData(
          meditationSessionNotifier,
          currentDate,
          currentDateStartOfTheWeek,
          currentDateEndOfTheWeek,
          selectedTimeFrame);
    }

    return whatChartToPresent;
  }

  @override
  Widget build(BuildContext context) {
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);

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
                  child: Text('<   '),
                  onTap: () {
                    if (selectedTimeFrame == 'DAY') {
                      decreaseDatePerDay(currentDate, selectedTimeFrame);
                    }
                    if (selectedTimeFrame == 'WEEK') {
                      decreaseDatePerWeek();
                    }
                    if (selectedTimeFrame == 'MONTH') {
                      decreaseDatePerMonth(currentDate, selectedTimeFrame);
                    }
                    if (selectedTimeFrame == 'YEAR') {
                      decreaseDatePerYear(currentDate, selectedTimeFrame);
                    }
                  }),
              whatDateToPresent(selectedTimeFrame),
              GestureDetector(
                child: Visibility(
                  visible: true, //isIncreaseSignNeedToVisible,
                  child: Text('   >'),
                ),
                onTap: () {
                  if (selectedTimeFrame == 'DAY') {
                    increaseDatePerDay(currentDate, selectedTimeFrame);
                  }
                  if (selectedTimeFrame == 'WEEK') {
                    increaseDatePerWeek();
                  }
                  if (selectedTimeFrame == 'MONTH') {
                    increaseDatePerMonth(currentDate, selectedTimeFrame);
                  }
                  if (selectedTimeFrame == 'YEAR') {
                    increaseDatePerYear(currentDate, selectedTimeFrame);
                  }
                },
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: whatChartToPresent(selectedTimeFrame),
            // if (selectedTimeFrame == 'DAY') {
            //      MeditationSessionsChartDay.withSampleData(meditationSessionNotifier, currentDate, currentDateStartOfTheWeek, currentDateEndOfTheWeek, selectedTimeFrame);
            //  }
          ),
        ],
      ),
    );
  }
}
