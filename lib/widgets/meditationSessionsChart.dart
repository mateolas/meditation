/// Example of a time series chart using a bar renderer.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:take_a_breath/notifier/meditationSession_notifier.dart';

class MeditationSessionsChart extends StatelessWidget {
  final List<charts.Series<MeditationSessionSeries, DateTime>> seriesList;
  final bool animate;

  MeditationSessionsChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  /// Takes three arguments:
  /// 1. currentDate - single date: day, month, year
  /// 2. currentDateStartOfTheWeek - date which holds beginning of particular week
  /// 3. currentDateEndOfTheWeek - date which holds end of the particular week
  factory MeditationSessionsChart.withSampleData(
      MeditationSessionNotifier meditationSessionNotifier,
      DateTime currentDate,
      DateTime currentDateStartOfTheWeek,
      DateTime currentDateEndOfTheWeek) {
    return new MeditationSessionsChart(
      _createSampleData(meditationSessionNotifier, currentDate,
          currentDateStartOfTheWeek, currentDateEndOfTheWeek),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      //formating of the xAxis
      domainAxis: new charts.DateTimeAxisSpec(
        tickProviderSpec: charts.DayTickProviderSpec(increments: [1]),
        tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
            day: new charts.TimeFormatterSpec(
                format: 'EEE', transitionFormat: 'EEE', noonFormat: 'EEE')),
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
          DateTime currentDateEndOfTheWeek) {
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

    final dataTestPerDay = <MeditationSessionSeries>[
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

    
    ///
    ///Preparing to show data PER WEEK///
    ///

    final dataTestPerWeek = <MeditationSessionSeries>[
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

    return [
      new charts.Series<MeditationSessionSeries, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (MeditationSessionSeries meditationSessionSeries, _) =>
            meditationSessionSeries.date,
        measureFn: (MeditationSessionSeries meditationSessionSeries, _) =>
            meditationSessionSeries.meditationSessionLength,
        data: dataTestPerWeek,
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
