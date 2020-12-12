import 'package:archive_your_bill/model/colors.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:archive_your_bill/api/hParameter_api.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;

class SaturationChartData extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  //from intl package formatter
  final formatter = new DateFormat.yMMMMd();

  SaturationChartData(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SaturationChartData.withSampleData(
      HParameterNotifier hParameterNotifier,
      String dayWeekTypeOfView) {
    //if list of hParameters is empty
    //draw an empty Chart
    if (hParameterNotifier.hParameterList.isEmpty) {
      return new SaturationChartData(
        _createSampleDataIfEmpty(),
        // Disable animations for image tests.
        animate: true,
      );
    }
    //if list of hParameters is not empty
    //draw chart based on data fetched from firebase (throught notifier)
    else {
      return new SaturationChartData(
        _createSampleData(hParameterNotifier, dayWeekTypeOfView),
        // Disable animations for image tests.
        animate: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spo2Formatter =
        new charts.BasicNumericTickFormatterSpec((num value) => '$value SpO\u2082 %');

    return Scaffold(
      body: new charts.TimeSeriesChart(
        seriesList,
        defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: true),
        animate: animate,
        primaryMeasureAxis: new charts.NumericAxisSpec(
          tickFormatterSpec: spo2Formatter,
          tickProviderSpec: new charts.StaticNumericTickProviderSpec(
            <charts.TickSpec<num>>[
              charts.TickSpec<num>(86),
              charts.TickSpec<num>(88),
              charts.TickSpec<num>(90),
              charts.TickSpec<num>(92),
              charts.TickSpec<num>(94),
              charts.TickSpec<num>(96),
              charts.TickSpec<num>(98),
              charts.TickSpec<num>(100),
            ],
          ),
        ),
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        behaviors: [
          new charts.SlidingViewport(),
          new charts.ChartTitle('Saturation',
              behaviorPosition: charts.BehaviorPosition.top,
              titleOutsideJustification: charts.OutsideJustification.middle,
              titleStyleSpec: charts.TextStyleSpec(
                  fontSize: 20,
                  color: charts.ColorUtil.fromDartColor(Colors.blue)),
              // Set a larger inner padding than the default (10) to avoid
              // rendering the text too close to the top measure axis tick label.
              // The top tick label may extend upwards into the top margin region
              // if it is located at the top of the draw area.
              outerPadding: 20,
              innerPadding: 20),
        ],
      ),
    );
  }

  /// Create one series with data fetched through hParameterNotifier from Firebase.
  static List<charts.Series<TimeSeriesSaturation, DateTime>> _createSampleData(
      HParameterNotifier hParameterNotifier,
      String temperatureDayWeekTypeOfView) {
    var now = new DateTime.now();
    var now_1d = now.subtract(Duration(days: 1));
    var now_1w = now.subtract(Duration(days: 7));
    var now_1m = new DateTime(now.year, now.month - 1, now.day);
    var now_1y = new DateTime(now.year - 1, now.month, now.day);
    var now_1000y = new DateTime(now.year - 1000, now.month, now.day);
    var timePeriod;

    switch (temperatureDayWeekTypeOfView) {
      case 'DAY':
        {
          timePeriod = now_1d;
        }
        break;

      case 'WEEK':
        {
          timePeriod = now_1w;
        }
        break;

      case 'MONTH':
        {
          timePeriod = now_1m;
        }
        break;

      case 'YEAR':
        {
          timePeriod = now_1y;
        }
        break;

      case 'ALL':
        {
          timePeriod = now_1000y;
        }
        break;

      default:
        {
          timePeriod = now_1d;
        }
        break;
    }

    //get data to present the chart
    //loop through all list items where:
    //- in proper "data frame" range
    //- parameter is not empty
    final data = <TimeSeriesSaturation>[
      //loop to get all the items from the hParameterList
      for (int i = 0; i < hParameterNotifier.hParameterList.length; i++)
        //check if it's last day, week or month
        if (timePeriod
            .isBefore(hParameterNotifier.hParameterList[i].createdAt.toDate())&& hParameterNotifier.hParameterList[i].saturation != null)
          new TimeSeriesSaturation(
              hParameterNotifier.hParameterList[i].createdAt.toDate(),
              double.parse(hParameterNotifier.hParameterList[i].saturation)),
    ];

    return [
      new charts.Series<TimeSeriesSaturation, DateTime>(
        id: 'Saturation',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSaturation saturation, _) => saturation.time,
        measureFn: (TimeSeriesSaturation saturation, _) =>
            saturation.saturation,
        data: data,
      )
    ];
  }
}

List<charts.Series<TimeSeriesSaturation, DateTime>>
    _createSampleDataIfEmpty() {
  final data = [
    new TimeSeriesSaturation(new DateTime.now(), 0),
  ];

  return [
    new charts.Series<TimeSeriesSaturation, DateTime>(
      id: 'Saturation',
      colorFn: (_, __) => charts.MaterialPalette.transparent,
      domainFn: (TimeSeriesSaturation saturation, _) => saturation.time,
      measureFn: (TimeSeriesSaturation saturation, _) =>
          saturation.saturation,
      data: data,
    )
  ];
}

/// Sample time series data type.
class TimeSeriesSaturation {
  final DateTime time;
  final double saturation;

  TimeSeriesSaturation(this.time, this.saturation);
}
