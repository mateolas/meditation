import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:provider/provider.dart';

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.withSampleData(HParameterNotifier hParameterNotifier) {
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
        _createSampleData(hParameterNotifier),
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
        // Optionally pass in a [DateTimeFactory] used by the chart. The factory
        // should create the same type of [DateTime] as the data provided. If none
        // specified, the default creates local date time.
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }

  /// Create one series with data fetched through hParameterNotifier from Firebase.
  static List<charts.Series<TimeSeriesTemperature, DateTime>> _createSampleData(
      HParameterNotifier hParameterNotifier) {

   //loop to get all the items from the hParameterList
    final data = <TimeSeriesTemperature>[

        for (int i = 0; i < hParameterNotifier.hParameterList.length; i++) 
    new TimeSeriesTemperature((hParameterNotifier.hParameterList[i].createdAt.toDate()),
           int.parse(hParameterNotifier.hParameterList[i].temperature)),


    ];

    return [
      new charts.Series<TimeSeriesTemperature, DateTime>(
        id: 'Temperature',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesTemperature temperature, _) => temperature.time,
        measureFn: (TimeSeriesTemperature temperature, _) => temperature.temperature,
        data: data,
      )
    ];
  }
}

List<charts.Series<TimeSeriesTemperature, DateTime>> _createSampleDataIfEmpty() {
  final data = [
    new TimeSeriesTemperature(new DateTime(2017, 9, 19), 1),
  ];

  return [
    new charts.Series<TimeSeriesTemperature, DateTime>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (TimeSeriesTemperature sales, _) => sales.time,
      measureFn: (TimeSeriesTemperature sales, _) => sales.temperature,
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
