/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class MeditationSessionsChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  MeditationSessionsChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }
}

/// Sample ordinal data type.
class MeditationSessions {
  final String date;
  final int lengthOfSession;

  MeditationSessions(this.date, this.lengthOfSession);
}
