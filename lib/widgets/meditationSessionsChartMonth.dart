/// Example of a time series chart using a bar renderer.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:take_a_breath/notifier/meditationSession_notifier.dart';
import 'package:provider/provider.dart';

class MeditationSessionsChartMonth extends StatelessWidget {
  final List<charts.Series<MeditationSessionSeries, DateTime>> seriesList;
  final bool animate;

  MeditationSessionsChartMonth(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  /// Takes three arguments:
  /// 1. currentDate - single date: day, month, year
  /// 2. currentDateStartOfTheWeek - date which holds beginning of particular week
  /// 3. currentDateEndOfTheWeek - date which holds end of the particular week
  factory MeditationSessionsChartMonth.withSampleData(
      MeditationSessionNotifier meditationSessionNotifier,
      DateTime currentDate,
      DateTime currentDateStartOfTheWeek,
      DateTime currentDateEndOfTheWeek,
      String selectedTimeFrame) {
    return new MeditationSessionsChartMonth(
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
    //instance of MeditationSessionNotifier to get selected month
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);
    int i = 0;
    //which month has been selected
    DateTime selectedMonth;
    selectedMonth = meditationSessionNotifier.getSelectedMonth;

    //setting to the last day of the selected month
    DateTime lastDayOfSelectedMonth =
        new DateTime(selectedMonth.year, selectedMonth.month + 1, 0);

    //number of days in selected month
    int nrOfDaysInSelectedMonth = lastDayOfSelectedMonth.day;

    //generating x axis description based of days of a month of selected month
    final staticTicks = <charts.TickSpec<DateTime>>[
      for (i = 1; i < nrOfDaysInSelectedMonth + 1; i++)
        new charts.TickSpec(
            DateTime.utc(
                selectedMonth.year, selectedMonth.month, selectedMonth.day + i),
            label: '$i'),
    ];

    print(
        "Selected month provider: ${meditationSessionNotifier.getSelectedMonth}");

    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      domainAxis: new charts.DateTimeAxisSpec(
          tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
              day: new charts.TimeFormatterSpec(
                  format: 'D', transitionFormat: 'D')),
          tickProviderSpec:
              new charts.StaticDateTimeTickProviderSpec(staticTicks)),
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

    ///Value to hold list of meditation sessions
    var data = <MeditationSessionSeries>[];

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

    //Data value (complete list of meditation sessions) depends on what time frame has been chosen

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
