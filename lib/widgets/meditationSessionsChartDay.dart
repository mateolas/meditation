/// Example of a time series chart using a bar renderer.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:take_a_breath/notifier/meditationSession_notifier.dart';

class MeditationSessionsChartDay extends StatelessWidget {
  final List<charts.Series<MeditationSessionSeries, DateTime>> seriesList;
  final bool animate;

  MeditationSessionsChartDay(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  /// Takes three arguments:
  /// 1. currentDate - single date: day, month, year
  /// 2. currentDateStartOfTheWeek - date which holds beginning of particular week
  /// 3. currentDateEndOfTheWeek - date which holds end of the particular week
  factory MeditationSessionsChartDay.withSampleData(
      MeditationSessionNotifier meditationSessionNotifier,
      DateTime currentDate,
      DateTime currentDateStartOfTheWeek,
      DateTime currentDateEndOfTheWeek,
      String selectedTimeFrame) {
    return new MeditationSessionsChartDay(
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
    // Create the ticks to be used the domain axis.
    final staticTicks = <charts.TickSpec<DateTime>>[
      new charts.TickSpec(DateTime.utc(2021, 5, 30, 0, 0)),
      new charts.TickSpec(DateTime.utc(2021, 5, 30, 2, 0)),
      new charts.TickSpec(DateTime.utc(2021, 5, 30, 4, 0)),
      new charts.TickSpec(DateTime.utc(2021, 5, 30, 6, 0)),
      new charts.TickSpec(DateTime.utc(2021, 5, 30, 8, 0)),
      new charts.TickSpec(DateTime.utc(2021, 5, 30, 10, 0)),
      new charts.TickSpec(DateTime.utc(2021, 5, 30, 12, 0)),
      new charts.TickSpec(DateTime.utc(2021, 5, 30, 14, 0)),
      new charts.TickSpec(DateTime.utc(2021, 5, 30, 16, 0)),
      new charts.TickSpec(DateTime.utc(2021, 5, 30, 18, 0)),
      new charts.TickSpec(DateTime.utc(2021, 5, 30, 20, 0)),
      new charts.TickSpec(DateTime.utc(2021, 5, 30, 22, 0)),
    ];

    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      domainAxis: new charts.DateTimeAxisSpec(
          tickProviderSpec:
              new charts.StaticDateTimeTickProviderSpec(staticTicks)),
    );
  }
  // final staticTicks = <charts.TickSpec<DateTime>>[
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 00, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 01, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 02, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 03, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 04, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 05, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 06, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 07, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 08, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 09, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 10, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 11, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 12, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 13, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 14, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 15, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 16, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 17, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 18, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 19, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 20, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 21, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 22, 00)),
  //   new charts.TickSpec(DateTime.utc(2021, 05, 29, 23, 00)),
  // ];

  // return new charts.TimeSeriesChart(
  //   seriesList,

  //   animate: animate,
  //   // Set the default renderer to a bar renderer.
  //   // This can also be one of the custom renderers of the time series chart.
  //   defaultRenderer: new charts.BarRendererConfig<DateTime>(),
  //   // It is recommended that default interactions be turned off if using bar
  //   // renderer, because the line point highlighter is the default for time
  //   // series chart.
  //   defaultInteractions: false,
  //   // If default interactions were removed, optionally add select nearest
  //   // and the domain highlighter that are typical for bar charts.

  //   // Optionally pass in a [DateTimeFactory] used by the chart. The factory
  //   // should create the same type of [DateTime] as the data provided. If none
  //   // specified, the default creates local date time.
  //   dateTimeFactory: const charts.LocalDateTimeFactory(),
  // );

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

    //Data value (complete list of meditation sessions) depends on what time frame has been chosen
    if (selectedTimeFrame == 'DAY') {
      data = dataPerDay;
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
