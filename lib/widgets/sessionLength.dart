// import 'package:flutter/material.dart';
// import 'package:health_parameters_tracker/notifier/meditationSession_notifier.dart';
// import 'package:provider/provider.dart';

// class SessionLength extends StatefulWidget {
//   final double lengthOfSession;

//   SessionLength(this.lengthOfSession);

//   @override
//   _SessionLength createState() =>
//       _SessionLength();
// }

// class _SessionLength extends State<SessionLength> {
//   @override
//   Widget build(BuildContext context) {
//     MeditationSessionNotifier meditationSessionNotifier =
//         Provider.of<MeditationSessionNotifier>(context);

//     meditationSessionNotifier.setLengthOfCurrentSession(widget.lengthOfSession);

//     var length = meditationSessionNotifier.getLengthOfCurrentSession();
//     print('Length in MeditationSesion class: $length');
//     print(length);

//     return Text(meditationSessionNotifier.getLengthOfCurrentSession());
//   }
// }
