import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter/material.dart';
import 'package:health_parameters_tracker/model/colors.dart';

class MeditationTimeSlider extends StatelessWidget {
  String percentageModifier(double value) {
    final roundedValue = value.ceil().toInt().toString();
    return '$roundedValue %';
  }

  String _printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

  final slider = SleekCircularSlider(
      min: 0,
      max: 120,
      initialValue: 30,
      onChangeStart: (double startValue) {
        startValue = 30;
      },
      onChangeEnd: (double endValue) {
        // ucallback providing an ending value (when a pan gesture ends)
      },
      // innerWidget: (double value) {
      //   Text('$value');
      //   // use your custom widget inside the slider (gets a slider value from the callback)
      // },
      appearance: CircularSliderAppearance(
          infoProperties: InfoProperties(modifier: (double value) {
            var roundedValue = value.ceil().toInt();
            final d1 = Duration(minutes: roundedValue);
            format(Duration d) => d.toString().split('.').first.padLeft(-10,"0");
            
            return ("${format(d1)}");//"$roundedValue min";
          }),
          customColors: CustomSliderColors(
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
