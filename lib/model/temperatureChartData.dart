import 'package:charts_flutter/flutter.dart' as charts;
import 'package:archive_your_bill/model/hParameter.dart';
import 'package:flutter/material.dart';

class TemperatureChartData {
  
  final String date;
  final int temperature;
   final charts.Color color;
  
 TemperatureChartData(this.date, this.temperature, Color color)
     : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}