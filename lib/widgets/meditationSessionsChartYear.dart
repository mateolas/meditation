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

    //get selected Year (using month which provides proper DateTime date)
    DateTime selectedYear;
    selectedYear = meditationSessionNotifier.getSelectedMonth;

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

    ///
    ///Preparing to show data PER YEAR///
    ///

    //First step is to copy to new list proper items from the current date
    //To make it, we're creating list of MedidationSessionSeries
    //Looping through list of MeditationSessionNotifier list we're copying data
    //when current date (which is date from time frame selected by user) is
    //equal to the selected year / month

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
    final List<List> dataFromAllMonths = [
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

    //loop to fill data of particular months
    for (int k = 0; k < 12; k++)
      for (int i = 0;
          i < meditationSessionNotifier.meditationSessionList.length;
          i++)
        //check if it's last day, week or month
        if (DateTime(currentDate.year, k + 1, 1).isBefore(
                meditationSessionNotifier.meditationSessionList[i].createdAt
                    .toDate()) &&
            DateTime(currentDate.year, k + 2, 1).isAfter(
                meditationSessionNotifier.meditationSessionList[i].createdAt
                    .toDate()))
          dataFromAllMonths[k].add(new MeditationSessionSeries(
              meditationSessionNotifier.meditationSessionList[i].createdAt
                  .toDate(),
              int.parse(
                  meditationSessionNotifier.meditationSessionList[i].length)));

    // //Total time in JAN
    // if (dataFromJAN.length != null) {
    //   for (int i = 0; i < dataFromJAN.length; i++)
    //     if (dataFromJAN[i].meditationSessionLength != null) {
    //       totalLengthOfJAN =
    //           totalLengthOfJAN + dataFromJAN[i].meditationSessionLength;
    //     }
    // }
    // //Total time in FEB
    // if (dataFromFEB.length != null) {
    //   for (int i = 0; i < dataFromFEB.length; i++)
    //     if (dataFromFEB[i].meditationSessionLength != null) {
    //       totalLengthOfFEB =
    //           totalLengthOfFEB + dataFromFEB[i].meditationSessionLength;
    //     }
    // }

    // //Total time in MAR
    // if (dataFromMAR.length != null) {
    //   for (int i = 0; i < dataFromMAR.length; i++)
    //     if (dataFromMAR[i].meditationSessionLength != null) {
    //       totalLengthOfMAR =
    //           totalLengthOfMAR + dataFromMAR[i].meditationSessionLength;
    //     }
    // }

    // //Total time in APR
    // if (dataFromAPR.length > 0) {
    //   for (int i = 0; i < dataFromAPR.length; i++)
    //     if (dataFromFEB[i].meditationSessionLength != null) {
    //       totalLengthOfAPR =
    //           totalLengthOfAPR + dataFromAPR[i].meditationSessionLength;
    //     } else {
    //       totalLengthOfAPR = 0;
    //     }
    // }

    // //Total time in MAY
    // if (dataFromMAY.length > 0) {
    //   for (int i = 0; i < dataFromMAY.length; i++)
    //     totalLengthOfMAY =
    //         totalLengthOfMAY + dataFromMAY[i].meditationSessionLength;
    // } else {
    //   totalLengthOfMAY = 0;
    // }
    // //Total time in JUN
    // if (dataFromJUN.length > 0) {
    //   for (int i = 0; i < dataFromJUN.length; i++)
    //     totalLengthOfJUN =
    //         totalLengthOfJUN + dataFromJUN[i].meditationSessionLength;
    // } else {
    //   totalLengthOfJUN = 0;
    // }
    // //Total time in JUL
    // if (dataFromJUL.length > 0) {
    //   for (int i = 0; i < dataFromJUL.length; i++)
    //     totalLengthOfJUL =
    //         totalLengthOfJUL + dataFromJUL[i].meditationSessionLength;
    // } else {
    //   totalLengthOfJUL = 0;
    // }
    // //Total time in AUG
    // if (dataFromAUG.length > 0) {
    //   for (int i = 0; i < dataFromAUG.length; i++)
    //     totalLengthOfAUG =
    //         totalLengthOfAUG + dataFromAUG[i].meditationSessionLength;
    // } else {
    //   totalLengthOfAUG = 0;
    // }
    // //Total time in SEP
    // if (dataFromSEP.length > 0) {
    //   for (int i = 0; i < dataFromSEP.length; i++)
    //     totalLengthOfSEP =
    //         totalLengthOfSEP + dataFromSEP[i].meditationSessionLength;
    // } else {
    //   totalLengthOfSEP = 0;
    // }
    // //Total time in OCT
    // if (dataFromOCT.length > 0) {
    //   for (int i = 0; i < dataFromOCT.length; i++)
    //     totalLengthOfOCT =
    //         totalLengthOfOCT + dataFromOCT[i].meditationSessionLength;
    // } else {
    //   totalLengthOfOCT = 0;
    // }
    // //Total time in NOV
    // if (dataFromNOV.length > 0) {
    //   for (int i = 0; i < dataFromNOV.length; i++)
    //     totalLengthOfNOV =
    //         totalLengthOfNOV + dataFromNOV[i].meditationSessionLength;
    // } else {
    //   totalLengthOfNOV = 0;
    // }
    // //Total time in DEC
    // if (dataFromDEC.length > 0) {
    //   for (int i = 0; i < dataFromDEC.length; i++)
    //     totalLengthOfDEC =
    //         totalLengthOfDEC + dataFromDEC[i].meditationSessionLength;
    // }

    //get total length of meditation sessions in January
    for (int k = 0; k < 12; k++)
      for (int i = 0; i < dataFromAllMonths[k].length; i++) {
        sessionLengthsPerMonth[k] =
            sessionLengthsPerMonth[k] + dataFromAllMonths[k].length;
        //[i][1][1]. dataFromJanuary[i].meditationSessionLength;
      }

    //loop to fill data of particular months
    for (int k = 0; k < 12; k++)
      for (int i = 0; i < dataFromAllMonths[k].length; i++)
        //check if it's last day, week or month
        sessionLengthsPerMonth[k] =
            sessionLengthsPerMonth[k] + dataFromAllMonths[k].length;

    //   for (int i = 0;
    //       i < meditationSessionNotifier.meditationSessionList.length;
    //       i++)
    //     //check if it's last day, week or month
    //     if (DateTime(currentDate.year, 1, 1).isBefore(meditationSessionNotifier
    //             .meditationSessionList[i].createdAt
    //             .toDate()) &&
    //         DateTime(currentDate.year, 2, 1).isAfter(meditationSessionNotifier
    //             .meditationSessionList[i].createdAt
    //             .toDate()))
    //       new MeditationSessionSeries(
    //           meditationSessionNotifier.meditationSessionList[i].createdAt
    //               .toDate(),
    //           int.parse(
    //               meditationSessionNotifier.meditationSessionList[i].length))
    // ];

    // //get total length of meditation sessions in January
    // int totalLengthOfSessionsJAN = 0;
    // for (int i = 0; i < dataFromJAN.length; i++) {
    //   totalLengthOfSessionsJAN =
    //       totalLengthOfSessionsJAN + dataFromJanuary[i].meditationSessionLength;
    // }

    // final dataOfTheYear = <MeditationSessionSeries>[
    //   new MeditationSessionSeries(
    //       DateTime(currentDate.year, 1, 1), totalLengthOfSessionsJAN)
    // ];

    return [
      new charts.Series<MeditationSessionSeries, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (MeditationSessionSeries meditationSessionSeries, _) =>
            meditationSessionSeries.date,
        measureFn: (MeditationSessionSeries meditationSessionSeries, _) =>
            meditationSessionSeries.meditationSessionLength,
        //holds the list which we created based on a time frame selection (day/week/month/year)
        data: dataFromJUL,
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
