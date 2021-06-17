/// Example of a time series chart using a bar renderer.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:take_a_breath/notifier/meditationSession_notifier.dart';
import 'package:provider/provider.dart';

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
    //instance of MeditationSessionNotifier to get selected week start/end day
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);

    DateTime selectedWeekStartDay;
    selectedWeekStartDay = meditationSessionNotifier.getSelectedWeekStartDay;

    /// FOR DEBUG
    //print(
    //    "Start week provider: ${meditationSessionNotifier.getSelectedWeekStartDay}");
    //print(
    //    "End week provider: ${meditationSessionNotifier.getSelectedWeekEndDay}");
    ///

    final staticTicks = <charts.TickSpec<DateTime>>[
      new charts.TickSpec(
          DateTime.utc(selectedWeekStartDay.year, selectedWeekStartDay.month,
              selectedWeekStartDay.day),
          label: 'MON'),
      new charts.TickSpec(
          DateTime.utc(selectedWeekStartDay.year, selectedWeekStartDay.month,
              selectedWeekStartDay.day + 1),
          label: 'TUE'),
      new charts.TickSpec(
          DateTime.utc(selectedWeekStartDay.year, selectedWeekStartDay.month,
              selectedWeekStartDay.day + 2),
          label: 'WED'),
      new charts.TickSpec(
          DateTime.utc(selectedWeekStartDay.year, selectedWeekStartDay.month,
              selectedWeekStartDay.day + 3),
          label: 'THU'),
      new charts.TickSpec(
          DateTime.utc(selectedWeekStartDay.year, selectedWeekStartDay.month,
              selectedWeekStartDay.day + 4),
          label: 'FRI'),
      new charts.TickSpec(
          DateTime.utc(selectedWeekStartDay.year, selectedWeekStartDay.month,
              selectedWeekStartDay.day + 5),
          label: 'SAT'),
      new charts.TickSpec(
          DateTime.utc(selectedWeekStartDay.year, selectedWeekStartDay.month,
              selectedWeekStartDay.day + 6),
          label: 'SUN'),
    ];

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

    //increase by one end date of the week to filter properly scope from MON to SUN
    DateTime currentDateEndOfTheWeekIncreased = DateTime.utc(
        currentDateEndOfTheWeek.year,
        currentDateEndOfTheWeek.month,
        currentDateEndOfTheWeek.day + 1);

    ///filtering and getting data of current week from provider
    final dataPerWeek = <MeditationSessionSeries>[
      for (int i = 0;
          i < meditationSessionNotifier.meditationSessionList.length;
          i++)
        if (currentDateStartOfTheWeek.isBefore(meditationSessionNotifier
                .meditationSessionList[i].createdAt
                .toDate()) &&
            currentDateEndOfTheWeekIncreased.isAfter(meditationSessionNotifier
                .meditationSessionList[i].createdAt
                .toDate()))
          new MeditationSessionSeries(
              meditationSessionNotifier.meditationSessionList[i].createdAt
                  .toDate(),
              int.parse(
                  meditationSessionNotifier.meditationSessionList[i].length))
    ];

    //creating empty list to store summarized values
    var summarizedDataPerWeek = <MeditationSessionSeries>[
      for (int i = 0; i < 7; i++)
        new MeditationSessionSeries(
            DateTime.utc(
                currentDateStartOfTheWeek.year,
                currentDateStartOfTheWeek.month,
                currentDateStartOfTheWeek.day + i),
            0)
    ];

    //two loops: i - loop, to iterate through "filtered" days of the current month
    //k - loop, to iterate through all days of the empty/template list (the same month as current one)
    for (int i = 0; i < dataPerWeek.length; i++)
      for (int k = 0; k < 7; k++)
        //when "filtered" day matches template day, add length to template day
        if (summarizedDataPerWeek[k].date.day == dataPerWeek[i].date.day) {
          //print("inLoop ${i}: ${dataPerMonth[i].date.day}");
          summarizedDataPerWeek[k].meditationSessionLength =
              summarizedDataPerWeek[k].meditationSessionLength +
                  dataPerWeek[i].meditationSessionLength;
        }

//for debugging //
    for (int i = 0; i < summarizedDataPerWeek.length; i++)
      print(
          "summarizedDataPerWeek ${i}: ${summarizedDataPerWeek[i].date} ${summarizedDataPerWeek[i].meditationSessionLength}");

    return [
      new charts.Series<MeditationSessionSeries, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (MeditationSessionSeries meditationSessionSeries, _) =>
            meditationSessionSeries.date,
        measureFn: (MeditationSessionSeries meditationSessionSeries, _) =>
            meditationSessionSeries.meditationSessionLength,
        //holds the list which we created based on a time frame selection (day/week/month/year)
        data: summarizedDataPerWeek,
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
