/// Example of a time series chart using a bar renderer.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:take_a_breath/notifier/meditationSession_notifier.dart';
import 'package:provider/provider.dart';

class MeditationSessionsChartYear extends StatelessWidget {
  final List<charts.Series<MeditationSessionSeries, DateTime>> seriesList;
  final bool animate;

  MeditationSessionsChartYear(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  /// Takes three arguments:
  /// 1. currentDate - single date: day, month, year
  /// 2. currentDateStartOfTheWeek - date which holds beginning of particular week
  /// 3. currentDateEndOfTheWeek - date which holds end of the particular week
  factory MeditationSessionsChartYear.withSampleData(
      MeditationSessionNotifier meditationSessionNotifier,
      DateTime currentDate,
      DateTime currentDateStartOfTheWeek,
      DateTime currentDateEndOfTheWeek,
      String selectedTimeFrame) {
    return new MeditationSessionsChartYear(
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

  @override
  Widget build(BuildContext context) {
    //instance of MeditationSessionNotifier to get selected year
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);

    ///TO - DO
    ///get selected year properly

    //get selected Year (using month which provides proper DateTime date)
    DateTime selectedYear;
    selectedYear = meditationSessionNotifier.getSelectedMonth;
    print("Selected year: ${selectedYear}");

    /// FOR DEBUG
    //print(
    //    "Start week provider: ${meditationSessionNotifier.getSelectedWeekStartDay}");
    //print(
    //    "End week provider: ${meditationSessionNotifier.getSelectedWeekEndDay}");
    ///

    final staticTicks = <charts.TickSpec<DateTime>>[
      new charts.TickSpec(DateTime.utc(selectedYear.year, 1), label: 'JAN'),
      new charts.TickSpec(DateTime.utc(selectedYear.year, 2), label: 'FEB'),
      new charts.TickSpec(DateTime.utc(selectedYear.year, 3), label: 'MAR'),
      new charts.TickSpec(DateTime.utc(selectedYear.year, 4), label: 'APR'),
      new charts.TickSpec(DateTime.utc(selectedYear.year, 5), label: 'MAY'),
      new charts.TickSpec(DateTime.utc(selectedYear.year, 6), label: 'JUN'),
      new charts.TickSpec(DateTime.utc(selectedYear.year, 7), label: 'JUL'),
      new charts.TickSpec(DateTime.utc(selectedYear.year, 8), label: 'AUG'),
      new charts.TickSpec(DateTime.utc(selectedYear.year, 9), label: 'SEP'),
      new charts.TickSpec(DateTime.utc(selectedYear.year, 10), label: 'OCT'),
      new charts.TickSpec(DateTime.utc(selectedYear.year, 11), label: 'NOV'),
      new charts.TickSpec(DateTime.utc(selectedYear.year, 12), label: 'DEC'),
    ];

    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      domainAxis: new charts.DateTimeAxisSpec(
          tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
              day: new charts.TimeFormatterSpec(format: 'M')),
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

    ///
    ///Preparing to show data PER YEAR///
    ///

    //integers to store summarize meditation sessions length per particular month
    int totalLengthOfJAN = 0;
    int totalLengthOfFEB = 0;
    int totalLengthOfMAR = 0;
    int totalLengthOfAPR = 0;
    int totalLengthOfMAY = 0;
    int totalLengthOfJUN = 0;
    int totalLengthOfJUL = 0;
    int totalLengthOfAUG = 0;
    int totalLengthOfSEP = 0;
    int totalLengthOfOCT = 0;
    int totalLengthOfNOV = 0;
    int totalLengthOfDEC = 0;

    //meditationSessions lists to store data per particular month
    final dataFromJAN = <MeditationSessionSeries>[];
    final dataFromFEB = <MeditationSessionSeries>[];
    final dataFromMAR = <MeditationSessionSeries>[];
    final dataFromAPR = <MeditationSessionSeries>[];
    final dataFromMAY = <MeditationSessionSeries>[];
    final dataFromJUN = <MeditationSessionSeries>[];
    final dataFromJUL = <MeditationSessionSeries>[];
    final dataFromAUG = <MeditationSessionSeries>[];
    final dataFromSEP = <MeditationSessionSeries>[];
    final dataFromOCT = <MeditationSessionSeries>[];
    final dataFromNOV = <MeditationSessionSeries>[];
    final dataFromDEC = <MeditationSessionSeries>[];

    //list of integers to store meditation sessions length per particular month
    final sessionLengthsPerMonth = <int>[
      totalLengthOfJAN,
      totalLengthOfFEB,
      totalLengthOfMAR,
      totalLengthOfAPR,
      totalLengthOfMAY,
      totalLengthOfJUN,
      totalLengthOfJUL,
      totalLengthOfAUG,
      totalLengthOfSEP,
      totalLengthOfOCT,
      totalLengthOfNOV,
      totalLengthOfDEC,
    ];

    //list of meditdations sessions lists from particular months
    final List<List> summarizedDataFromAllMonths = [
      dataFromJAN,
      dataFromFEB,
      dataFromMAR,
      dataFromAPR,
      dataFromMAY,
      dataFromJUN,
      dataFromJUL,
      dataFromAUG,
      dataFromSEP,
      dataFromOCT,
      dataFromNOV,
      dataFromDEC
    ];

    ///Loop to fill data of particular month of the chosen year
    ///k - loop through items in list summarizedDataFromAllMonths
    ///i - loop through all items in the provider list
    ///if - filtering proper range of dates
    for (int k = 0; k < 12; k++)
      for (int i = 0;
          i < meditationSessionNotifier.meditationSessionList.length;
          i++)
        //if chosen date is between "1st" of this month and "1st" the next month
        if (DateTime(currentDate.year, k + 1, 1).isBefore(
                meditationSessionNotifier.meditationSessionList[i].createdAt
                    .toDate()) &&
            DateTime(currentDate.year, k + 2, 1).isAfter(
                meditationSessionNotifier.meditationSessionList[i].createdAt
                    .toDate()))
          summarizedDataFromAllMonths[k].add(new MeditationSessionSeries(
              meditationSessionNotifier.meditationSessionList[i].createdAt
                  .toDate(),
              int.parse(
                  meditationSessionNotifier.meditationSessionList[i].length)));

    ///Loop to calculate summarized time per particular month of the chosen year
    /// k - loop through the items of the list summarizedDataFromAllMonths
    /// k - summarize meditation session length of particular month (from particular item
    /// from list summarizedDataFromAllMonths)
    /// [k][i] - access to the attribute of the item in the list which is in
    /// another list

    for (int k = 0; k < 12; k++) {
      for (int i = 0; i < summarizedDataFromAllMonths[k].length; i++) {
        sessionLengthsPerMonth[k] = sessionLengthsPerMonth[k] +
            summarizedDataFromAllMonths[k][i].meditationSessionLength;
      }
    }

    ///Final list where are stored Meditations Sessions:
    ///First attribue - Month
    ///Second attribute - Meditation session length per particular month
    final dataWithTotalLengthsAllMonths = <MeditationSessionSeries>[
      for (int i = 0; i < 12; i++)
        new MeditationSessionSeries(
            DateTime.utc(currentDate.year, i + 1), sessionLengthsPerMonth[i]),
    ];

    //draw the chart based on dataWithTotalLengthsAllMonths data
    return [
      new charts.Series<MeditationSessionSeries, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (MeditationSessionSeries meditationSessionSeries, _) =>
            meditationSessionSeries.date,
        measureFn: (MeditationSessionSeries meditationSessionSeries, _) =>
            meditationSessionSeries.meditationSessionLength,
        //holds the list which we created based on a time frame selection (day/week/month/year)
        data: dataWithTotalLengthsAllMonths,
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
