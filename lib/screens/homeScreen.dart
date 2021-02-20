import 'package:take_a_breath/api/meditationSession_api.dart';
import 'package:take_a_breath/notifier/auth_notifier.dart';
import 'package:take_a_breath/notifier/bill_notifier.dart';
import 'package:take_a_breath/notifier/units_notifier.dart';
import 'package:take_a_breath/notifier/meditationSession_notifier.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:take_a_breath/screens/sideMenu.dart';
import 'package:take_a_breath/screens/meditationSessionScreen.dart';
import 'package:take_a_breath/screens/meditationStatistics.dart';
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

  //Controller for type of screen to present
  TabController _typeOfScreenToPresentController;

  //determine the "roundness" of tab bars
  var radius = Radius.circular(32);

  //what type of screen is selected with a tab controller
  String selectedTypeOfScreen;

  //Names of screens to present at the bottom of the app
  List listOfScreens = [
    'HOME',
    'PROGRESS',
    'LITERATURE',
    'NEWS',
  ];

  Widget whatScreenToPresent(String typeOfScreen) {
    switch (typeOfScreen) {
      case 'HOME':
        {
          return MeditationSessionScreen();
        }
        break;

      case 'PROGRESS':
        {
          return MeditationStatistics();
        }
        break;

      case 'LITERATURE':
        {
          return MeditationStatistics();
        }
        break;

      case 'NEWS':
        {
          return MeditationStatistics();
        }
        break;

      default:
        {
          return MeditationStatistics();
        }
        break;
    }
  }

  @override
  void initState() {
    selectedTypeOfScreen = 'HOME';
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
    print('$selectedTypeOfScreen');
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: ConvexAppBar(
            items: [
              TabItem(icon: Icons.home, title: 'Home'),
              TabItem(icon: Icons.map, title: 'Progress'),
              TabItem(icon: Icons.add, title: 'Literature'),
              TabItem(icon: Icons.message, title: 'News'),
              TabItem(icon: Icons.people, title: 'Profile'),
            ],
            backgroundColor: Colors.orange[600],
            height: MediaQuery.of(context).size.height / 14,
            curve: Curves.easeInOut,
            top: -10,
            initialActiveIndex: 0, //optional, default as 0
            onTap: (int i) => {
                  setState(() {
                    selectedTypeOfScreen = listOfScreens[i];
                  })
                }),
        drawer: SideMenu(),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: true, // hides default back button
          backgroundColor: Colors.transparent,
          elevation: 0,
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
        body: whatScreenToPresent(selectedTypeOfScreen),
      ),
    );
  }
}
