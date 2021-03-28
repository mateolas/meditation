/// Example of a time series chart using a bar renderer.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:take_a_breath/notifier/meditationSession_notifier.dart';

class MeditationSessionsChart extends StatelessWidget {
  final List<charts.Series<MeditationSessionSeries, DateTime>> seriesList;
  final bool animate;

  MeditationSessionsChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory MeditationSessionsChart.withSampleData(
      MeditationSessionNotifier meditationSessionNotifier, DateTime currentDate) {
    return new MeditationSessionsChart(
      _createSampleData(meditationSessionNotifier, currentDate),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
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
  static List<charts.Series<MeditationSessionSeries, DateTime>> _createSampleData(
      MeditationSessionNotifier meditationSessionNotifier, DateTime currentDate) {
    var now = new DateTime.now();
    var now_1d = now.subtract(Duration(days: 1));
    var timePeriod;
    timePeriod = now_1d;

    final dataTest = <MeditationSessionSeries> [for (int i = 0; i < meditationSessionNotifier.meditationSessionList.length; i++)
        //check if it's last day, week or month
        if (currentDate.day
             == meditationSessionNotifier.meditationSessionList[i].createdAt.toDate().day)
          new MeditationSessionSeries(
              meditationSessionNotifier.meditationSessionList[i].createdAt.toDate(),
              int.parse(meditationSessionNotifier.meditationSessionList[i].length))];

    final data = [
      new MeditationSessionSeries(new DateTime(2017, 9, 1), 5),
      new MeditationSessionSeries(new DateTime(2017, 9, 2), 5),
      new MeditationSessionSeries(new DateTime(2017, 9, 3), 25),
      new MeditationSessionSeries(new DateTime(2017, 9, 4), 100),
      new MeditationSessionSeries(new DateTime(2017, 9, 5), 75),
      new MeditationSessionSeries(new DateTime(2017, 9, 6), 88),
      new MeditationSessionSeries(new DateTime(2017, 9, 7), 65),
      new MeditationSessionSeries(new DateTime(2017, 9, 8), 91),
      new MeditationSessionSeries(new DateTime(2017, 9, 9), 100),
      new MeditationSessionSeries(new DateTime(2017, 9, 10), 111),
      new MeditationSessionSeries(new DateTime(2017, 9, 11), 90),
      new MeditationSessionSeries(new DateTime(2017, 9, 12), 50),
      new MeditationSessionSeries(new DateTime(2017, 9, 13), 40),
      new MeditationSessionSeries(new DateTime(2017, 9, 14), 30),
      new MeditationSessionSeries(new DateTime(2017, 9, 15), 40),
      new MeditationSessionSeries(new DateTime(2017, 9, 16), 50),
      new MeditationSessionSeries(new DateTime(2017, 9, 17), 30),
      new MeditationSessionSeries(new DateTime(2017, 9, 18), 35),
      new MeditationSessionSeries(new DateTime(2017, 9, 19), 40),
      new MeditationSessionSeries(new DateTime(2017, 9, 20), 32),
      new MeditationSessionSeries(new DateTime(2017, 9, 21), 31),
    ];

    return [
      new charts.Series<MeditationSessionSeries, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (MeditationSessionSeries meditationSessionSeries, _) => meditationSessionSeries.date,
        measureFn: (MeditationSessionSeries meditationSessionSeries, _) => meditationSessionSeries.meditationSessionLength,
        data: dataTest,
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
