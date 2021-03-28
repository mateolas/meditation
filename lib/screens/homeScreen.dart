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

  //variable to hold title of the screen
  String titleOfTheScreen = 'Take a breath';

  //Names of screens to present at the bottom of the app
  List listOfScreens = [
    'Home',
    'Progress',
    'Literature',
    'News',
    'Profile'
  ];

  //function to present proper page depends on the item
  //picked from the tab bar menu
  Widget whatScreenToPresent(String typeOfScreen) {
    switch (typeOfScreen) {
      case 'Home':
        {
          return MeditationSessionScreen();
        }
        break;

      case 'Progress':
        {
          return MeditationStatistics();
        }
        break;

      case 'Literature':
        {
          return MeditationStatistics();
        }
        break;

      case 'News':
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
    selectedTypeOfScreen = 'Home';
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
            backgroundColor: Colors.orange[700],
            height: MediaQuery.of(context).size.height / 15,
            curve: Curves.easeInOut,
            top: -8,
            initialActiveIndex: 0, //optional, default as 0
            //function which gives number of the selected item
            onTap: (int i) => {
                  setState(() {
                    //assign item from the list of the screen names to the selected screen
                    selectedTypeOfScreen = listOfScreens[i];
                    //if function to define AppBar title
                    //if home screen set title to 'Take a breath'
                    //in any other case assign proper name based on the list
                    if (i == 0) {
                      titleOfTheScreen = 'Take a breath';
                    } else {
                      titleOfTheScreen = listOfScreens[i];
                    }
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
            titleOfTheScreen,
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
        //what type of screen to present based on a chosen tabBar selection
        body: whatScreenToPresent(selectedTypeOfScreen),
      ),
    );
  }
}
