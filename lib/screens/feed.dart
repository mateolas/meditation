import 'package:archive_your_bill/api/hParameter_api.dart';
import 'package:archive_your_bill/model/colors.dart';
import 'package:archive_your_bill/model/temperatureChartData.dart';
import 'package:archive_your_bill/notifier/auth_notifier.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:archive_your_bill/screens/addParameter.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:archive_your_bill/model/globals.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive_your_bill/model/dateCheck.dart';
import 'package:archive_your_bill/model/hParameter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

//https://medium.com/@agungsurya/take-a-screenshot-of-a-certain-widget-in-flutter-ad263edc4e55

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with SingleTickerProviderStateMixin {
  //what temperature time frame was selected: Day/Week/Month/Year/All
  String selectedTimeTempView;
  //Controller for bottom tab (temp, saturation etc.)
  TabController _bottomTabcontroller;
  //Controller for time frame tab (day, week, month etc.)
  TabController _timeTempTimeViewController;
  //Name of screens to present for TabBar
  List bottomTabScreensNames = [
    'All',
    'Temperature',
    'Pulse',
    'Saturation',
    'Weight',
  ];

  //Name of time frames to present for TabBar
  List timeTempView = [
    'DAY',
    'WEEK',
    'MONTH',
    'YEAR',
    'ALL',
  ];

  @override
  void initState() {
    //initializing notifier to fetch data from firebase
    HParameterNotifier hParameterNotifier =
        Provider.of<HParameterNotifier>(context, listen: false);
    //fetching data from firebase
    getHParameters(hParameterNotifier);
    //setting default temperature time frame view for 'Day'
    selectedTimeTempView = 'Day';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    HParameterNotifier hParemterNotifier =
        Provider.of<HParameterNotifier>(context);

    print("1 Building Feed");
    print('2 Authnotifier ${authNotifier.user.displayName}');
    print(
        "3 BUILD RESULT LIST LENGTH: ${hParemterNotifier.hParameterList.length}");
    print('Temperature day/week view value: $selectedTimeTempView');

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false, // hides default back button
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff56ab2f),
                  Color(0xffa8e063),
                ],
              ),
            ),
          ),
          title: Text(
            'Health parameters tracker',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: <Widget>[
            // action button - logout
            FlatButton(
              onPressed: () => signout(authNotifier),
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 26.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            //card to hold chart + buttons
            Card(
              elevation: 12,
              child: Column(
                children: [
                  Padding(
                    padding: new EdgeInsets.fromLTRB(6, 0, 0, 6),
                    child: SizedBox(
                      //size of the chart
                      //smaller value causes faults
                      height: 304,
                      //prints chart
                      child: SimpleTimeSeriesChart.withSampleData(
                          hParemterNotifier, selectedTimeTempView),
                    ),
                  ),
                  //tab controller for temperature time frame
                  DefaultTabController(
                    length: timeTempView.length,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                      child: TabBar(
                        onTap: (index) {
                          setState(() {
                            //set the name of temperature time frame
                            //selectedTimeTempView used as an argument in "draw a chart" function
                            selectedTimeTempView = timeTempView[index];
                          });
                        },

                        controller: _timeTempTimeViewController,
                        isScrollable: true,
                        labelStyle: TextStyle(
                          fontSize: 12.0,
                        ),
                        //For Selected tab
                        unselectedLabelStyle: TextStyle(
                          fontSize: 12.0,
                        ), //For Un-selected Tabs
                        //funtion to generate tabs
                        tabs: new List.generate(bottomTabScreensNames.length,
                            (index) {
                          return new Tab(
                            iconMargin: EdgeInsets.only(bottom: 3),
                            text: timeTempView[index].toUpperCase(),
                          );
                        }),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  //Row for buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                        child: Row(
                          children: [
                            //Add button
                            ButtonTheme(
                              //widht - half of the screen
                              minWidth: MediaQuery.of(context).size.width / 3.5,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: accentCustomColor),
                                ),
                                child: Text(
                                  'ADD',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                color: accentCustomColor,
                                //After pressing button modal botton sheet will appear
                                onPressed: () => showModalBottomSheet<void>(
                                    context: context,
                                    backgroundColor: Colors.white,
                                    //AddParameter - custom Class to add parameter
                                    builder: (context) => new AddParameter()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('DETAILS'),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            //for(var item in hParemterNotifier.hParameterList ) Text(item.temperature)
          ],
        ),
        bottomNavigationBar: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DefaultTabController(
              length: bottomTabScreensNames.length,
              child: new AnimatedCrossFade(
                firstChild: new Material(
                  color: Theme.of(context).primaryColor,
                  child: new TabBar(
                    controller: _bottomTabcontroller,
                    isScrollable: true,
                    tabs: new List.generate(bottomTabScreensNames.length,
                        (index) {
                      return new Tab(
                        text: bottomTabScreensNames[index].toUpperCase(),
                      );
                    }),
                  ),
                ),
                secondChild: new Container(),
                crossFadeState: CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
