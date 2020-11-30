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
        animate: false,
      );
    } 
    //if list of hParameters is not empty
    //draw chart based on data fetched from firebase (throught notifier)
    else {
      return new SimpleTimeSeriesChart(
        _createSampleData(hParameterNotifier),
        // Disable animations for image tests.
        animate: false,
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

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(
      HParameterNotifier hParameterNotifier) {
    final data = [
      new TimeSeriesSales(new DateTime(2017, 9, 19),
          int.parse(hParameterNotifier.hParameterList[0].temperature)),
      new TimeSeriesSales(new DateTime(2017, 9, 26),
          int.parse(hParameterNotifier.hParameterList[1].temperature)),
      new TimeSeriesSales(new DateTime(2017, 10, 3),
          int.parse(hParameterNotifier.hParameterList[2].temperature)),
      new TimeSeriesSales(new DateTime(2017, 10, 10),
          int.parse(hParameterNotifier.hParameterList[3].temperature)),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

List<charts.Series<TimeSeriesSales, DateTime>> _createSampleDataIfEmpty() {
  final data = [
    new TimeSeriesSales(new DateTime(2017, 9, 19), 1),
  ];

  return [
    new charts.Series<TimeSeriesSales, DateTime>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (TimeSeriesSales sales, _) => sales.time,
      measureFn: (TimeSeriesSales sales, _) => sales.sales,
      data: data,
    )
  ];
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
