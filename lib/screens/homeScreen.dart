import 'package:health_parameters_tracker/api/hParameter_api.dart';
import 'package:health_parameters_tracker/notifier/auth_notifier.dart';
import 'package:health_parameters_tracker/notifier/bill_notifier.dart';
import 'package:health_parameters_tracker/notifier/units_notifier.dart';
import 'package:health_parameters_tracker/notifier/meditationSession_notifier.dart';

import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:health_parameters_tracker/screens/sideMenu.dart';
import 'package:health_parameters_tracker/screens/meditationSessionScreen.dart';
import 'package:health_parameters_tracker/screens/meditationStatistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 
  //Controller of a page swipping. Manages swipe detection and provides animation.
  final pageController = PageController(initialPage: 0);
  
  @override
  void initState() {  
    super.initState();
  }

   @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Notifier to have possibility of loging in/out from the app
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    return Scaffold(
      //background color behing the appbar
      extendBodyBehindAppBar: true,
      drawer: SideMenu(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true, // hides default back button
        backgroundColor: Colors.transparent,
        title: Text(
          'Take a breath',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          // action button - logout
          FlatButton(
            onPressed: () => signOutGoogle(authNotifier),
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
              size: 26.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        children: [
         MeditationSessionScreen(),
         MeditationStatistics(),
        ],
      ),
    );
  }
}
