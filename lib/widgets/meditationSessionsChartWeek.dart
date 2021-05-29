/// Example of a time series chart using a bar renderer.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:take_a_breath/notifier/meditationSession_notifier.dart';

class MeditationSessionsChartWeek extends StatelessWidget {
  final List<charts.Series<MeditationSessionSeries, DateTime>> seriesList;
  final bool animate;

  MeditationSessionsChartWeek(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  /// Takes three arguments:
  /// 1. currentDate - single date: day, month, year
  /// 2. currentDateStartOfTheWeek - date which holds beginning of particular week
  /// 3. currentDateEndOfTheWeek - date which holds end of the particular week
  factory MeditationSessionsChartWeek.withSampleData(
      MeditationSessionNotifier meditationSessionNotifier,
      DateTime currentDate,
      DateTime currentDateStartOfTheWeek,
      DateTime currentDateEndOfTheWeek,
      String selectedTimeFrame) {
    return new MeditationSessionsChartWeek(
      _createSampleData(
          meditationSessionNotifier,
          currentDate,
          currentDateStartOfTheWeek,
          currentDateEndOfTheWeek,
          selectedTimeFrame),
      // Disable animations for image tests.
      animate: false,
    );
  }

  //Interesting link about static tick provider
  //https://google.github.io/charts/flutter/example/axes/statically_provided_ticks.html

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      //formating of the xAxis
      domainAxis: new charts.DateTimeAxisSpec(
          //  tickProviderSpec: charts.DayTickProviderSpec(increments: [1]),
          // tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
          //     day: new charts.TimeFormatterSpec(
          //        format: 'EEE', transitionFormat: 'EEE', noonFormat: 'EEE')),
          ),
      animate: animate,
      // Set the default renderer to a bar renderer.
      // This can also be one of the custom renderers of the time series chart.
      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      // It is recommended that default interactions be turned off if using bar
      // renderer, because the line point highlighter is the default for time
      // series chart.
      defaultInteractions: false,
      // If default interactions were removed, optionally add select nearest
      // and the domain highlighter that are typical for bar charts.
      behaviors: [new charts.SelectNearest(), new charts.DomainHighlighter()],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<MeditationSessionSeries, DateTime>>
      _createSampleData(
          MeditationSessionNotifier meditationSessionNotifier,
          DateTime currentDate,
          DateTime currentDateStartOfTheWeek,
          DateTime currentDateEndOfTheWeek,
          String selectedTimeFrame) {
    var now = new DateTime.now();
    var now_1d = now.subtract(Duration(days: 1));
    var timePeriod;
    timePeriod = now_1d;
    var totalTimePerDay = 0;

    ///
    ///Preparing to show data PER DAY///
    ///

    //First step is to copy to new list items from the current date
    //To make it, we're creating dataTest list of MedidationSessionSeries
    //Looping through list of MeditationSessionNotifier list we're copying data
    //when current date (which is date from time frame selected by customer) is
    //equal to the item from the list

    final dataPerDay = <MeditationSessionSeries>[
      for (int i = 0;
          i < meditationSessionNotifier.meditationSessionList.length;
          i++)
        //check if it's last day, week or month
        if (currentDate.day ==
            meditationSessionNotifier.meditationSessionList[i].createdAt
                .toDate()
                .day)
          new MeditationSessionSeries(
              meditationSessionNotifier.meditationSessionList[i].createdAt
                  .toDate(),
              int.parse(
                  meditationSessionNotifier.meditationSessionList[i].length))
    ];

    //loop the get the total time per day (per current Date)
    for (int i = 0;
        i < meditationSessionNotifier.meditationSessionList.length;
        i++) {
      //check if it's last day, week or month
      if (currentDate.day ==
          meditationSessionNotifier.meditationSessionList[i].createdAt
              .toDate()
              .day) {
        totalTimePerDay = totalTimePerDay +
            int.parse(
                meditationSessionNotifier.meditationSessionList[i].length);
      }
    }
    print("Total length time per day $totalTimePerDay");

    ///Value to hold list of meditation sessions
    var data = <MeditationSessionSeries>[];

    ///
    ///Preparing to show data PER WEEK///
    ///

    final dataPerWeek = <MeditationSessionSeries>[
      for (int i = 0;
          i < meditationSessionNotifier.meditationSessionList.length;
          i++)
        if (currentDateStartOfTheWeek.isBefore(meditationSessionNotifier
                .meditationSessionList[i].createdAt
                .toDate()) &&
            currentDateEndOfTheWeek.isAfter(meditationSessionNotifier
                .meditationSessionList[i].createdAt
                .toDate()))
          new MeditationSessionSeries(
              meditationSessionNotifier.meditationSessionList[i].createdAt
                  .toDate(),
              int.parse(
                  meditationSessionNotifier.meditationSessionList[i].length))
    ];

    ///
    ///Preparing to show data PER MONTH///
    ///

    //Get the number of days of particular month

    DateTime lastDayOfMonth =
        new DateTime(currentDate.year, currentDate.month + 1, 0);
    print("Current date: ${currentDate}");
    print("N days: ${lastDayOfMonth.day}");

    final dataPerMonth = <MeditationSessionSeries>[
      for (int i = 0;
          i < meditationSessionNotifier.meditationSessionList.length;
          i++)
        if (currentDateStartOfTheWeek.isBefore(meditationSessionNotifier
                .meditationSessionList[i].createdAt
                .toDate()) &&
            currentDateEndOfTheWeek.isAfter(meditationSessionNotifier
                .meditationSessionList[i].createdAt
                .toDate()))
          new MeditationSessionSeries(
              meditationSessionNotifier.meditationSessionList[i].createdAt
                  .toDate(),
              int.parse(
                  meditationSessionNotifier.meditationSessionList[i].length))
    ];

    dataPerMonth
        .add(MeditationSessionSeries((DateTime(2021, 5, 1, 12, 00)), 1));
    dataPerMonth
        .add(MeditationSessionSeries((DateTime(2021, 5, 31, 12, 00)), 1));

    //Data value (complete list of meditation sessions) depends on what time frame has been chosen
    if (selectedTimeFrame == 'DAY') {
      data = dataPerDay;
    }
    if (selectedTimeFrame == 'WEEK') {
      data = dataPerWeek;
    }
    if (selectedTimeFrame == 'MONTH') {
      data = dataPerMonth;
    }

    return [
      new charts.Series<MeditationSessionSeries, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (MeditationSessionSeries meditationSessionSeries, _) =>
            meditationSessionSeries.date,
        measureFn: (MeditationSessionSeries meditationSessionSeries, _) =>
            meditationSessionSeries.meditationSessionLength,
        //holds the list which we created based on a time frame selection (day/week/month/year)
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class MeditationSessionSeries {
  final DateTime date;
  final int meditationSessionLength;

  MeditationSessionSeries(this.date, this.meditationSessionLength);
}
