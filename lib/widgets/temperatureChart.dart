import 'package:flutter/material.dart';
import 'package:archive_your_bill/api/hParameter_api.dart';
import 'package:archive_your_bill/model/colors.dart';
import 'package:archive_your_bill/model/hParameter.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:archive_your_bill/model/temperatureChartData.dart';
import 'package:archive_your_bill/screens/addTemperatureParameter.dart';
import 'package:archive_your_bill/screens/temperatureDetails.dart';
import 'package:flutter/rendering.dart';

class TemperatureChart extends StatefulWidget {
  TemperatureChart();

  @override
  _TemperatureChartState createState() => _TemperatureChartState();
}

class _TemperatureChartState extends State<TemperatureChart> {
  //what temperature time frame was selected: Day/Week/Month/Year/All
  String selectedTimeTempView;

  //Name of time frames to present for TabBar
  List timeTempView = [
    'DAY',
    'WEEK',
    'MONTH',
    'YEAR',
    'ALL',
  ];

  //Controller for time frame tab (day, week, month etc.)
  TabController _timeTempTimeViewController;

  //calling initState function to initialize _currentHparameter
  @override
  void initState() {
    super.initState();
    HParameterNotifier hParameterNotifier =
        Provider.of<HParameterNotifier>(context, listen: false);
    //fetching data from firebase
    getHParameters(hParameterNotifier);
    //setting default temperature time frame view for 'Day'
    selectedTimeTempView = 'Day';
  }

  @override
  Widget build(BuildContext context) {
    HParameterNotifier hParameterNotifier =
        Provider.of<HParameterNotifier>(context, listen: false);

    return Card(
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
              child: LineChart.withSampleData(
                  hParameterNotifier, selectedTimeTempView),
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
                tabs: new List.generate(timeTempView.length, (index) {
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
                          style: TextStyle(fontSize: 14, color: Colors.white),
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
              ButtonTheme(
                //widht - half of the screen
                minWidth: MediaQuery.of(context).size.width / 3.5,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: accentCustomColor),
                  ),
                  child: Text(
                    'DETAILS',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  color: accentCustomColor,
                  //After pressing button modal botton sheet will appear
                  onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      backgroundColor: Colors.white,
                      //AddParameter - custom Class to add parameter
                      builder: (context) => new TemperatureDetails()),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
