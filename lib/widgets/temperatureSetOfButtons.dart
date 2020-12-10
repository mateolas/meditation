import 'package:flutter/material.dart';
import 'package:archive_your_bill/api/hParameter_api.dart';
import 'package:archive_your_bill/model/colors.dart';
import 'package:archive_your_bill/model/hParameter.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:archive_your_bill/model/temperatureChartData.dart';
import 'package:archive_your_bill/model/weightChartData.dart';
import 'package:archive_your_bill/model/saturationChartData.dart';
import 'package:archive_your_bill/model/pulseChartData.dart';
import 'package:archive_your_bill/screens/addTemperatureParameter.dart';
import 'package:archive_your_bill/screens/temperatureDetails.dart';
import 'package:flutter/rendering.dart';

class TemperatureSetOfButtons extends StatelessWidget {
  TemperatureSetOfButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                accentCustomColor,
                primaryCustomColor,
              ],
            ),
          ),
          child: MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const StadiumBorder(),
            child: Text('ADD',
                style: TextStyle(fontSize: 14, color: Colors.white)),
            onPressed: () => showModalBottomSheet<void>(
                context: context,
                backgroundColor: Colors.white,
                builder: (context) => new AddTemperatureParameter()),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                accentCustomColor,
                primaryCustomColor,
              ],
            ),
          ),
          child: MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const StadiumBorder(),
            child: Text('DETAILS',
                style: TextStyle(fontSize: 14, color: Colors.white)),
            onPressed: () => showModalBottomSheet<void>(
                context: context,
                backgroundColor: Colors.white,
                //AddParameter - custom Class to add parameter
                builder: (context) => new TemperatureDetails()),
          ),
        ),
      ],
    );
  }
}
