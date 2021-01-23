import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter/material.dart';
import 'package:health_parameters_tracker/model/colors.dart';

class MeditationTimeSlider extends StatelessWidget {
  final slider = SleekCircularSlider(
      appearance: CircularSliderAppearance(),
      onChange: (double value) {
        print(value);
      });

  @override
  Widget build(BuildContext context) {
    return slider;
  }
}
