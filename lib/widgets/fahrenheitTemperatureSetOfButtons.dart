import 'package:flutter/material.dart';
import 'package:health_parameters_tracker/model/colors.dart';

import 'package:health_parameters_tracker/screens/addFahrenheitTemperatureParameter.dart';
import 'package:health_parameters_tracker/screens/FahrenheittemperatureDetails.dart';
import 'package:flutter/rendering.dart';

class FahrenheitTemperatureSetOfButtons extends StatelessWidget {
  FahrenheitTemperatureSetOfButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: accentCustomColor,
          ),
          child: MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const StadiumBorder(),
            child: Text('ADD',
                style: TextStyle(fontSize: 14, color: Colors.white)),
            onPressed: () => showModalBottomSheet<void>(
                context: context,
                backgroundColor: Colors.white,
                builder: (context) => new AddFahrenheitTemperatureParameter()),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: accentCustomColor,
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
                builder: (context) => new FahrenheitTemperatureDetails()),
          ),
        ),
      ],
    );
  }
}
