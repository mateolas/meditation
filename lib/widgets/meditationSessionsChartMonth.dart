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
      DateTime currentMonth,
      DateTime currentDateStartOfTheWeek,
      DateTime currentDateEndOfTheWeek,
      String selectedTimeFrame) {
    return new MeditationSessionsChartMonth(
      _createSampleData(
          meditationSessionNotifier,
          currentDate,
          currentMonth,
          currentDateStartOfTheWeek,
          currentDateEndOfTheWeek,
          selectedTimeFrame),
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
          DateTime currentMonth,
          DateTime currentDateStartOfTheWeek,
          DateTime currentDateEndOfTheWeek,
          String selectedTimeFrame) {
    ///Value to hold list of meditation sessions
    var data = <MeditationSessionSeries>[];

    //to present statistics
    int totalTimeSpent = 0;
    int averageTimeSpent = 0;
    int nrOfNonEmptyDays = 0;

    ///
    ///Preparing to show data PER MONTH///
    ///

    //Set the date to the first day of current month
    DateTime firstDayOfMonth =
        new DateTime(currentMonth.year, currentMonth.month, 1);
    //Set the date to the last day of current month
    DateTime lastDayOfMonth =
        new DateTime(currentMonth.year, currentMonth.month + 1, 0);
    //Set the date to first day of next month to current
    DateTime firstDayOfNextMonth =
        new DateTime(currentMonth.year, currentMonth.month + 1, 1);

    // For debugging //
    // print("Current date: ${currentDate}");
    // print("First date of a month: ${firstDayOfMonth}");
    // print("Last date of a month: ${firstDayOfNextMonth}");
    // // // // // // //

    //filtering and getting data of current month from provider
    final dataPerMonth = <MeditationSessionSeries>[
      for (int i = 0;
          i < meditationSessionNotifier.meditationSessionList.length;
          i++)
        //filtering range: before first day of the month and after first day of next month
        //(last day of current month)
        if (firstDayOfMonth.isBefore(meditationSessionNotifier
                .meditationSessionList[i].createdAt
                .toDate()) &&
            firstDayOfNextMonth.isAfter(meditationSessionNotifier
                .meditationSessionList[i].createdAt
                .toDate()))
          //add filtered new MeditationSessionSeries object (date, length)
          new MeditationSessionSeries(
              meditationSessionNotifier.meditationSessionList[i].createdAt
                  .toDate(),
              int.parse(
                  meditationSessionNotifier.meditationSessionList[i].length))
    ];

    //sorting meditations sessions to find the longest session and setting
    //number of sessions
    if (dataPerMonth.length != 0) {
      meditationSessionNotifier.setNumberOfSessions(dataPerMonth.length);
      dataPerMonth.sort((a, b) =>
          b.meditationSessionLength.compareTo(a.meditationSessionLength));
    }

    //from sorted list setting the first item as the longest one
    if (dataPerMonth.length != 0) {
      meditationSessionNotifier
          .setLongestTimeSpent(dataPerMonth[0].meditationSessionLength);
    }

    //if data is empty, set the session length to 0
    if (dataPerMonth.length == 0) {
      meditationSessionNotifier.setLongestTimeSpent(0);
    }

    //creating empty list to store summarized values
    var summarizedDataPerMonth = <MeditationSessionSeries>[
      for (int i = 0; i < lastDayOfMonth.day; i++)
        new MeditationSessionSeries(
            DateTime.utc(firstDayOfMonth.year, firstDayOfMonth.month,
                firstDayOfMonth.day + i),
            0)
    ];

    //two loops: i - loop, to iterate through "filtered" days of the current month
    //k - loop, to iterate through all days of the empty/template list (the same month as current one)
    for (int i = 0; i < dataPerMonth.length; i++)
      for (int k = 0; k < summarizedDataPerMonth.length; k++)
        //when "filtered" day matches template day, add length to template day
        if (summarizedDataPerMonth[k].date.day == dataPerMonth[i].date.day) {
          print("inLoop ${i}: ${dataPerMonth[i].date.day}");
          summarizedDataPerMonth[k].meditationSessionLength =
              summarizedDataPerMonth[k].meditationSessionLength +
                  dataPerMonth[i].meditationSessionLength;
        }

    //total time spent per week
    for (int i = 0; i < summarizedDataPerMonth.length; i++) {
      totalTimeSpent =
          totalTimeSpent + summarizedDataPerMonth[i].meditationSessionLength;
    }

    //setting notifier to present statistics
    meditationSessionNotifier.setTotalTimeSpent(totalTimeSpent);

    //how many days non empty
    for (int i = 0; i < summarizedDataPerMonth.length; i++) {
      if (summarizedDataPerMonth[i].meditationSessionLength != 0)
        nrOfNonEmptyDays = nrOfNonEmptyDays + 1;
    }

    //average time spent
    if (nrOfNonEmptyDays == 0) {
      averageTimeSpent = 0;
    } else {
      averageTimeSpent = (totalTimeSpent / dataPerMonth.length).round();
    }

    //setting notifier to present statistics
    meditationSessionNotifier.setAverageTimeSpent(averageTimeSpent);

    // for debugging //
    // for (int i = 0; i < dataPerMonth.length; i++)
    //   print(
    //       "dataPerMonth ${i}: ${dataPerMonth[i].date} ${dataPerMonth[i].meditationSessionLength}");
    // for (int i = 0; i < summarizedDataPerMonth.length; i++)
    //   print(
    //       "summarizedDataPerMonth ${i}: ${summarizedDataPerMonth[i].date} ${summarizedDataPerMonth[i].meditationSessionLength}");
    // // // // // // //

    if (selectedTimeFrame == 'MONTH') {
      //data = dataPerMonth;
      data = summarizedDataPerMonth;
    }

    return [
      new charts.Series<MeditationSessionSeries, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
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
