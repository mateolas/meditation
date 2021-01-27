import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter/material.dart';
import 'package:health_parameters_tracker/model/colors.dart';

//COUNT DOWN TIMER
//https://pub.dev/packages/countdown_flutter


class MeditationTimeSlider extends StatelessWidget {
  final slider = SleekCircularSlider(
      min: 0,
      max: 180,
      initialValue: 45,
      onChangeStart: (double startValue) {
        startValue = 30;
      },
      onChangeEnd: (double endValue) {
        print(
            "End value: $endValue"); // ucallback providing an ending value (when a pan gesture ends)
      },
      // innerWidget: (double value) {
      //   Text('$value');
      //   // use your custom widget inside the slider (gets a slider value from the callback)
      // },
      appearance: CircularSliderAppearance(
          startAngle: 150,
          angleRange: 355,
          customWidths: CustomSliderWidths(progressBarWidth: 18),
          size: 280,
          infoProperties: InfoProperties(
              mainLabelStyle: TextStyle(color: Colors.white, fontSize: 40),
              modifier: (double value) {
                var roundedValue = value.toInt();
                //one line function
                String twoDigits(int n) => n.toString().padLeft(2, "0");
                //changing int into Duration
                final d1 = Duration(minutes: roundedValue);

                String twoDigitMinutes = twoDigits(d1.inMinutes.remainder(200));
                return "$twoDigitMinutes min";
              }),
          customColors: CustomSliderColors(
            trackColor: Colors.white,
            progressBarColors: [
              Color(0xffFFE000),
              Color(0xffe65c00),
            ],
          )),
      onChange: (double value) {
        print(value);
      });

  @override
  Widget build(BuildContext context) {
    return slider;
  }
}
