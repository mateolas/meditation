import 'package:flutter/material.dart';
import 'package:health_parameters_tracker/screens/addPulseParameter.dart';
//import 'package:health_parameters_tracker/screens/PulseMeasurementMainPage.dart';
import 'package:health_parameters_tracker/screens/pulseDetails.dart';
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
                //TODO: Work with pulse measurement
                // child: OutlineButton(
                //     disabledBorderColor: Colors.red,
                //     borderSide: BorderSide(color: Colors.red),
                //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //     shape: const StadiumBorder(),
                //     child: Text('MEASURE',
                //         style: TextStyle(fontSize: 14, color: Colors.red)),
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => PulseMeasurementMainPage()),
                //       );
                //     }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
