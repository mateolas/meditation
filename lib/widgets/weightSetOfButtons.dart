import 'package:flutter/material.dart';
import 'package:archive_your_bill/screens/addWeightParameter.dart';
import 'package:archive_your_bill/screens/weightDetails.dart';
import 'package:flutter/rendering.dart';

class WeightSetOfButtons extends StatelessWidget {
  WeightSetOfButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: Colors.purple,
          ),
          child: MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const StadiumBorder(),
            child: Text('ADD',
                style: TextStyle(fontSize: 14, color: Colors.white)),
            onPressed: () => showModalBottomSheet<void>(
                context: context,
                backgroundColor: Colors.white,
                builder: (context) => new AddWeightParameter()),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: Colors.purple,
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
                builder: (context) => new WeightDetails()),
          ),
        ),
      ],
    );
  }
}
