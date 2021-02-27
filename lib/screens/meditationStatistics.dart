import 'package:flutter/material.dart';
import 'package:take_a_breath/model/colors.dart';
import 'package:provider/provider.dart';
import 'package:take_a_breath/widgets/meditationSessionsChart.dart';
import 'package:take_a_breath/widgets/meditationSessionsChart.dart';
import 'package:take_a_breath/api/meditationSession_api.dart';
import 'package:take_a_breath/notifier/meditationSession_notifier.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import 'package:flutter/rendering.dart';

class MeditationStatistics extends StatefulWidget {
  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2013', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

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
  }

  //date to present currently "active" date
  DateTime currentDate;
  //date to present first day of the week (based on provided date)
  DateTime currentDateStartOfTheWeek;
  //date to present last day of the week (based on provided date)
  DateTime currentDateEndOfTheWeek;

  // Find the first date of the week which contains the provided date.
  DateTime findFirstDateOfTheWeek(
    DateTime dateTime,
  ) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  //Find last date of the week which contains provided date.
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  //function to decrease the presemted date based on chosen time frame
  DateTime decreaseDate(DateTime time, String typeOfTimeFrame) {
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
  DateTime increaseDate(DateTime time, String typeOfTimeFrame) {
    int timeFrameValue;
    if (typeOfTimeFrame == 'DAY') {
      timeFrameValue = 1;
      //value to compare currentDate
      DateTime currentDay = DateTime.now();
      if (DateTime(currentDate.year, currentDate.month, currentDate.day)
          .isAtSameMomentAs(DateTime(
              currentDay.year, currentDay.month, currentDay.day - 1))) {
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

  Widget whatDateToPresent(String selectedTimeFrame) {
    if (selectedTimeFrame == "DAY") {
      return Text('${DateFormat.yMMMd().format(currentDate)}');
    }

    if (selectedTimeFrame == "WEEK") {
      return Text(
          '${DateFormat.yMMMd().format(currentDateStartOfTheWeek)} - ${DateFormat.yMMMd().format(currentDateEndOfTheWeek)}');
    }
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
                    //set the name of temperature time frame
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Text('<   '),
                onTap: () {
                  decreaseDate(currentDate, selectedTimeFrame);
                },
              ),
             whatDateToPresent(selectedTimeFrame),
              GestureDetector(
                child: Visibility(
                  visible: isIncreaseSignNeedToVisible,
                  child: Text('   >'),
                ),
                onTap: () {
                  increaseDate(currentDate, selectedTimeFrame);
                },
              ),
            ],
          ),
          Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: MeditationSessionsChart(
                  MeditationStatistics._createSampleData(),
                  animate: false)),
        ],
      ),
    );
  }
}
