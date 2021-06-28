/// Example of a time series chart using a bar renderer.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:take_a_breath/notifier/meditationSession_notifier.dart';
import 'package:provider/provider.dart';

class MeditationSessionsChartDay extends StatelessWidget {
  final List<charts.Series<MeditationSessionSeries, DateTime>> seriesList;
  final bool animate;

  MeditationSessionsChartDay(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  /// Takes three arguments:
  /// 1. currentDate - single date: day, month, year
  /// 2. currentDateStartOfTheWeek - date which holds beginning of particular week
  /// 3. currentDateEndOfTheWeek - date which holds end of the particular week
  /// 4. selectedTimeFrame - what time frame has been selected: Day/Week/Month/Year
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

  @override
  Widget build(BuildContext context) {
    //instance of MeditationSessionNotifier to get current selected day
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);
    //variable to store current date from provider
    DateTime selectedDay;
    selectedDay = meditationSessionNotifier.getSelectedDay;

    // Create the ticks to be used the domain axis.
    final staticTicks = <charts.TickSpec<DateTime>>[
      new charts.TickSpec(
          DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day, 0),
          label: '0'),
      new charts.TickSpec(
          DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day, 2),
          label: '02'),
      new charts.TickSpec(
          DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day, 4),
          label: '04'),
      new charts.TickSpec(
          DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day, 6),
          label: '06'),
      new charts.TickSpec(
          DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day, 8),
          label: '08'),
      new charts.TickSpec(
          DateTime.utc(
              selectedDay.year, selectedDay.month, selectedDay.day, 10),
          label: '10'),
      new charts.TickSpec(
          DateTime.utc(
              selectedDay.year, selectedDay.month, selectedDay.day, 12),
          label: '12'),
      new charts.TickSpec(
          DateTime.utc(
              selectedDay.year, selectedDay.month, selectedDay.day, 14),
          label: '14'),
      new charts.TickSpec(
          DateTime.utc(
              selectedDay.year, selectedDay.month, selectedDay.day, 16),
          label: '16'),
      new charts.TickSpec(
          DateTime.utc(
              selectedDay.year, selectedDay.month, selectedDay.day, 18),
          label: '18'),
      new charts.TickSpec(
          DateTime.utc(
              selectedDay.year, selectedDay.month, selectedDay.day, 20),
          label: '20'),
      new charts.TickSpec(
          DateTime.utc(
              selectedDay.year, selectedDay.month, selectedDay.day, 22),
          label: '22'),
      new charts.TickSpec(
          DateTime.utc(
              selectedDay.year, selectedDay.month, selectedDay.day + 1, 00),
          label: '24'),
    ];

    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      domainAxis: new charts.DateTimeAxisSpec(
          tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
              hour: new charts.TimeFormatterSpec(
                  format: 'H', transitionFormat: 'H')),
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
    var totalTimePerDay = 0;

    //to present statistics
    int totalTimeSpent = 0;
    int averageTimeSpent = 0;
    int nrOfNonEmptyDays = 0;

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
                    .day &&
            currentDate.month ==
                meditationSessionNotifier.meditationSessionList[i].createdAt
                    .toDate()
                    .month &&
            currentDate.year ==
                meditationSessionNotifier.meditationSessionList[i].createdAt
                    .toDate()
                    .year)
          new MeditationSessionSeries(
              meditationSessionNotifier.meditationSessionList[i].createdAt
                  .toDate(),
              int.parse(
                  meditationSessionNotifier.meditationSessionList[i].length))
    ];

    //sorting meditations sessions to find the longest session and setting
    //number of sessions
    if (dataPerDay.length != 0) {
      meditationSessionNotifier.setNumberOfSessions(dataPerDay.length);
      dataPerDay.sort((a, b) =>
          b.meditationSessionLength.compareTo(a.meditationSessionLength));
    }

    //from sorted list setting the first item as the longest one
    if (dataPerDay.length != 0) {
      meditationSessionNotifier
          .setLongestTimeSpent(dataPerDay[0].meditationSessionLength);
    }

    //if data is empty, set the session length to 0
    if (dataPerDay.length == 0) {
      meditationSessionNotifier.setLongestTimeSpent(0);
    }

    //total time spent per week
    for (int i = 0; i < dataPerDay.length; i++) {
      totalTimePerDay = totalTimePerDay + dataPerDay[i].meditationSessionLength;
    }

    //setting notifier to present statistics
    meditationSessionNotifier.setTotalTimeSpent(totalTimePerDay);

    //average time spent
    if (dataPerDay.length == 0) {
      averageTimeSpent = 0;
    } else {
      averageTimeSpent = (totalTimePerDay / dataPerDay.length).round();
    }

    print("Total time $totalTimeSpent");
    print("Length dataPerDay${dataPerDay.length}");
    print("Average time spent per day $averageTimeSpent");

    //setting notifier to present statistics
    meditationSessionNotifier.setAverageTimeSpent(averageTimeSpent);
    print("Average time spent per day $averageTimeSpent");

    return [
      new charts.Series<MeditationSessionSeries, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (MeditationSessionSeries meditationSessionSeries, _) =>
            meditationSessionSeries.date,
        measureFn: (MeditationSessionSeries meditationSessionSeries, _) =>
            meditationSessionSeries.meditationSessionLength,
        //holds the list which we created based on a time frame selection (day/week/month/year)
        data: dataPerDay,
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
