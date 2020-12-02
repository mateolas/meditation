import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:archive_your_bill/api/bill_api.dart';

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  //from intl package formatter
  final formatter = new DateFormat.yMMMMd();

  SimpleTimeSeriesChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.withSampleData(
      HParameterNotifier hParameterNotifier,
      String temperatureDayWeekTypeOfView) {
    //if list of hParameters is empty
    //draw an empty Chart
    if (hParameterNotifier.hParameterList.isEmpty) {
      return new SimpleTimeSeriesChart(
        _createSampleDataIfEmpty(),
        // Disable animations for image tests.
        animate: true,
      );
    }
    //if list of hParameters is not empty
    //draw chart based on data fetched from firebase (throught notifier)
    else {
      return new SimpleTimeSeriesChart(
        _createSampleData(hParameterNotifier, temperatureDayWeekTypeOfView),
        // Disable animations for image tests.
        animate: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new charts.TimeSeriesChart(
        seriesList,
        animate: animate,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        behaviors: [
          new charts.SlidingViewport(),
          new charts.PanAndZoomBehavior(),
          //setting the title of the chart
          new charts.ChartTitle('Temperature',
              behaviorPosition: charts.BehaviorPosition.top,
              titleOutsideJustification: charts.OutsideJustification.middle,
              titleStyleSpec: charts.TextStyleSpec(fontSize: 14),
              // Set a larger inner padding than the default (10) to avoid
              // rendering the text too close to the top measure axis tick label.
              // The top tick label may extend upwards into the top margin region
              // if it is located at the top of the draw area.
              innerPadding: 12),
        ],
      ),
    );
  }

  /// Create one series with data fetched through hParameterNotifier from Firebase.
  static List<charts.Series<TimeSeriesTemperature, DateTime>> _createSampleData(
      HParameterNotifier hParameterNotifier,
      String temperatureDayWeekTypeOfView) {
    var now = new DateTime.now();
    var now_1d = now.subtract(Duration(days: 1));
    var now_1w = now.subtract(Duration(days: 7));
    var now_1m = new DateTime(now.year, now.month - 1, now.day);
    var now_1y = new DateTime(now.year - 1, now.month, now.day);
    var timePeriod;

    switch (temperatureDayWeekTypeOfView) {
      case 'Day':
        {
          timePeriod = now_1d;
        }
        break;

      case 'Week':
        {
          timePeriod = now_1w;
        }
        break;

      case 'Month':
        {
          timePeriod = now_1m;
        }
        break;

      case 'Year':
        {
          timePeriod = now_1y;
        }
        break;

      default:
        {
          timePeriod = now_1d;
        }
        break;
    }

    //final data = <TimeSeriesTemperature>[];

    final data = <TimeSeriesTemperature>[
      //loop to get all the items from the hParameterList
      for (int i = 0; i < hParameterNotifier.hParameterList.length; i++)
        //check if it's last day, week or month
        if (timePeriod
            .isBefore(hParameterNotifier.hParameterList[i].createdAt.toDate()))
          new TimeSeriesTemperature(
              hParameterNotifier.hParameterList[i].createdAt.toDate(),
              int.parse(hParameterNotifier.hParameterList[i].temperature)),
    ];

    // if (temperatureDayWeekTypeOfView == 'Day') {
    //   print('We are in the _createSample function DAY if');
    //   var dataDay = <TimeSeriesTemperature>[
    //     //loop to get all the items from the hParameterList
    //     for (int i = 0; i < hParameterNotifier.hParameterList.length; i++)
    //       //check if it's last day, week or month
    //       if (now_1d.isBefore(
    //           hParameterNotifier.hParameterList[i].createdAt.toDate()))
    //         new TimeSeriesTemperature(
    //             hParameterNotifier.hParameterList[i].createdAt.toDate(),
    //             int.parse(hParameterNotifier.hParameterList[i].temperature)),
    //   ];
    // }

    // if (temperatureDayWeekTypeOfView == 'Week') {
    //   print('We are in the _createSample function Week if');
    //   var dataWeek = <TimeSeriesTemperature>[
    //     //loop to get all the items from the hParameterList
    //     for (int i = 0; i < hParameterNotifier.hParameterList.length; i++)
    //       //check if it's last day, week or month
    //       if (now_1d.isBefore(
    //           hParameterNotifier.hParameterList[i].createdAt.toDate()))
    //         new TimeSeriesTemperature(
    //             hParameterNotifier.hParameterList[i].createdAt.toDate(),
    //             int.parse(hParameterNotifier.hParameterList[i].temperature)),
    //   ];
    // }


    return [
      new charts.Series<TimeSeriesTemperature, DateTime>(
        id: 'Temperature',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesTemperature temperature, _) => temperature.time,
        measureFn: (TimeSeriesTemperature temperature, _) =>
            temperature.temperature,
        data: data,
      )
    ];
  }
}

List<charts.Series<TimeSeriesTemperature, DateTime>>
    _createSampleDataIfEmpty() {
  final data = [
    new TimeSeriesTemperature(new DateTime.now(), 4),
  ];

  return [
    new charts.Series<TimeSeriesTemperature, DateTime>(
      id: 'Temperature',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (TimeSeriesTemperature temperature, _) => temperature.time,
      measureFn: (TimeSeriesTemperature temperature, _) =>
          temperature.temperature,
      data: data,
    )
  ];
}

/// Sample time series data type.
class TimeSeriesTemperature {
  final DateTime time;
  final int temperature;

  TimeSeriesTemperature(this.time, this.temperature);
}