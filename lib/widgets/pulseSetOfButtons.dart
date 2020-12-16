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
import 'package:archive_your_bill/screens/addPulseParameter.dart';
import 'package:archive_your_bill/screens/PulseMeasurementMainPage.dart';
import 'package:archive_your_bill/screens/pulseDetails.dart';
import 'package:flutter/rendering.dart';

class PulseSetOfButtons extends StatelessWidget {
  PulseSetOfButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3.5,
              decoration: ShapeDecoration(
                shape: const StadiumBorder(),
                color: Colors.red,
              ),
              child: MaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const StadiumBorder(),
                child: Text('ADD',
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Colors.white,
                    builder: (context) => new AddPulseParameter()),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3.5,
              decoration: ShapeDecoration(
                shape: const StadiumBorder(),
                color: Colors.red,
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
                    builder: (context) => new PulseDetails()),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 3.5,
                decoration: ShapeDecoration(
                  shape: const StadiumBorder(),
                  color: Colors.white,
                ),
                child: OutlineButton(
                    disabledBorderColor: Colors.red,
                    borderSide: BorderSide(color: Colors.red),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const StadiumBorder(),
                    child: Text('MEASURE',
                        style: TextStyle(fontSize: 14, color: Colors.red)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PulseMeasurementMainPage()),
                      );
                    }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
