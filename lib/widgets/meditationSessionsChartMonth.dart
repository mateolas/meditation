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
    return new charts.TimeSeriesChart(
      seriesList,
      //formating of the xAxis
      domainAxis: new charts.DateTimeAxisSpec(
        tickProviderSpec: charts.DayTickProviderSpec(increments: [2]),
        tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
            day: new charts.TimeFormatterSpec(
                format: 'dd', transitionFormat: 'dd', noonFormat: 'dd')),
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
    ///Value to hold list of meditation sessions
    var data = <MeditationSessionSeries>[];

    ///
    ///Preparing to show data PER MONTH///
    ///

    //Set the first day of current month
    DateTime firstDayOfMonth =
        new DateTime(currentDate.year, currentDate.month, 1);
    //Set the last day of current
    DateTime lastDayOfMonth =
        new DateTime(currentDate.year, currentDate.month + 1, 0);
    //Set the first day of next month to current
    DateTime firstDayOfNextMonth =
        new DateTime(currentDate.year, currentDate.month + 1, 1);
    print("Current date: ${currentDate}");
    print("First date of a month: ${firstDayOfMonth}");
    print("Last date of a month: ${firstDayOfNextMonth}");

    //getting data of the particular month
    final dataPerMonth = <MeditationSessionSeries>[
      for (int i = 0;
          i < meditationSessionNotifier.meditationSessionList.length;
          i++)
        if (firstDayOfMonth.isBefore(meditationSessionNotifier
                .meditationSessionList[i].createdAt
                .toDate()) &&
            firstDayOfNextMonth.isAfter(meditationSessionNotifier
                .meditationSessionList[i].createdAt
                .toDate()))
          new MeditationSessionSeries(
              meditationSessionNotifier.meditationSessionList[i].createdAt
                  .toDate(),
              int.parse(
                  meditationSessionNotifier.meditationSessionList[i].length))
    ];

    //create Empty List
    var summarizedDataPerMonth = <MeditationSessionSeries>[
      for (int i = 0; i < lastDayOfMonth.day; i++)
        new MeditationSessionSeries(
            DateTime.utc(firstDayOfMonth.year, firstDayOfMonth.month,
                firstDayOfMonth.day + i),
            0)
    ];

    // // for (int i = 0; i < dataPerMonth.length; i++)
    // //   if (dataPerMonth[i].date.day == dataPerMonth[i + 1].date.day) {
    // //     summarizedDataPerMonth[i].meditationSessionLength =
    // //         summarizedDataPerMonth[i].meditationSessionLength +
    // //             dataPerMonth[i].meditationSessionLength;
    // //   }

    //for (int i = 0; i < summarizedDataPerMonth.length; i++) {
    // print("dataPerMonthTemplate ${i}: ${summarizedDataPerMonth[i].date}");

    //Data value (complete list of meditation sessions) depends on what time frame has been chosen

    if (selectedTimeFrame == 'MONTH') {
      //data = dataPerMonth;
      data = summarizedDataPerMonth;
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
  int meditationSessionLength;

  MeditationSessionSeries(this.date, this.meditationSessionLength);
}
