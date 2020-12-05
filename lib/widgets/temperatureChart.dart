import 'package:flutter/material.dart';
import 'package:archive_your_bill/api/hParameter_api.dart';
import 'package:archive_your_bill/model/colors.dart';
import 'package:archive_your_bill/model/hParameter.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';

class TemperatureChart extends StatefulWidget {
  TemperatureChart();

  @override
  _TemperatureChartState createState() => _TemperatureChartState();
}

class _TemperatureChartState extends State<TemperatureChart> {
  //Hparameter which will be "uploading"
  Hparameter _currentHparameter;
  //new decimal picker
  NumberPicker decimalNumberPicker;
  //default value of a decimal picker
  double _currentDoubleValue = 36.6;

  //calling initState function to initialize _currentHparameter
  @override
  void initState() {
    super.initState();
    //initiate _currentHparameter
    _currentHparameter = Hparameter();
  }

  @override
  Widget build(BuildContext context) {


    



  }
}
