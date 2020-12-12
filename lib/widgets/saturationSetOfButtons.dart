import 'package:flutter/material.dart';
import 'package:archive_your_bill/screens/addSaturationParameter.dart';
import 'package:archive_your_bill/screens/SaturationDetails.dart';
import 'package:flutter/rendering.dart';

class SaturationSetOfButtons extends StatelessWidget {
  SaturationSetOfButtons();

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
                Colors.blue,
                Colors.blue[100],
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
                builder: (context) => new AddSaturationParameter()),
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
                Colors.blue,
                Colors.blue[100],
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
                builder: (context) => new SaturationDetails()),
          ),
        ),
      ],
    );
  }
}
