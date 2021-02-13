import 'package:take_a_breath/notifier/bill_notifier.dart';
import 'package:take_a_breath/notifier/meditationSession_notifier.dart';
import 'package:provider/provider.dart';

import './screens/homeScreen.dart';
import './screens/login.dart';
import 'package:flutter/material.dart';

import 'model/colors.dart';
import 'notifier/auth_notifier.dart';
import 'notifier/units_notifier.dart';


void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => HParameterNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => UnitsNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => MeditationSessionNotifier(),
        ),
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meditation',
      theme: ThemeData(
        primarySwatch: primaryCustomColor,
        accentColor: accentCustomColor,
        //fontFamily: 'Calibri',
      ),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          return notifier.user != null ? HomeScreen() : Login();
        },
      ),
    );
  }
}
