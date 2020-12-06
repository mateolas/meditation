import 'package:flutter/material.dart';
import 'package:archive_your_bill/api/hParameter_api.dart';
import 'package:archive_your_bill/model/colors.dart';
import 'package:archive_your_bill/model/hParameter.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:archive_your_bill/model/temperatureChartData.dart';
import 'package:archive_your_bill/model/weightChartData.dart';
import 'package:archive_your_bill/model/saturationChartData.dart';
import 'package:archive_your_bill/model/pressureChartData.dart';
import 'package:archive_your_bill/widgets/temperatureSetOfButtons.dart';
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
  String selectedTypeOfCharts;
  //determine the "roundness" of tab bars
  var radius = Radius.circular(32);

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

//Name of time frames to present for TabBar
  List typesOfCharts = [
    'TEMPERATURE',
    'PULSE',
    'SATURATION',
    'WEIGHT',
  ];

  //Controller for type of chart
  TabController _typeOfChartController;

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

  Widget whatTypeOfChartToPresent(HParameterNotifier hParameterNotifier, String typesOfCharts, String selectedTimeTempView){

   switch(typesOfCharts) { 
   case 'TEMPERATURE': { 
    return  TemperatureChartData.withSampleData(
                  hParameterNotifier, selectedTimeTempView);
   } 
   break; 
  
   case 'PULSE': { 
      return PressureChartData.withSampleData(
                  hParameterNotifier, selectedTimeTempView);
   } 
   break; 

    case 'SATURATION': { 
      return SaturationChartData.withSampleData(
                  hParameterNotifier, selectedTimeTempView);
   } 
   break; 

   case 'WEIGHT': { 
      return WeightChartData.withSampleData(
                  hParameterNotifier, selectedTimeTempView);
   } 
   break; 
      
   default: { 
         return TemperatureChartData.withSampleData(
                  hParameterNotifier, selectedTimeTempView);
   }
   break; 
} 

  }

  Widget whatTypeOfButtonsToPresent(HParameterNotifier hParameterNotifier, String typesOfCharts, String selectedTimeTempView){

   switch(typesOfCharts) { 
   case 'TEMPERATURE': { 
    return  TemperatureChartData.withSampleData(
                  hParameterNotifier, selectedTimeTempView);
   } 
   break; 
  
   case 'PULSE': { 
      return PressureChartData.withSampleData(
                  hParameterNotifier, selectedTimeTempView);
   } 
   break; 

    case 'SATURATION': { 
      return SaturationChartData.withSampleData(
                  hParameterNotifier, selectedTimeTempView);
   } 
   break; 

   case 'WEIGHT': { 
      return WeightChartData.withSampleData(
                  hParameterNotifier, selectedTimeTempView);
   } 
   break; 
      
   default: { 
         return TemperatureChartData.withSampleData(
                  hParameterNotifier, selectedTimeTempView);
   }
   break; 
} 

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
              height: 340,
              //prints chart
              child: whatTypeOfChartToPresent(hParameterNotifier, selectedTypeOfCharts, selectedTimeTempView)
            ),
          ),
          /// tab controller for time frame ///
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
          SizedBox(height: 4),
          /// tab controller for type of chart (Temperature, pressure, etc.) ///
          DefaultTabController(
            length: typesOfCharts.length,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
              child: Container(
                height: 32,
                child: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  onTap: (index) {
                    setState(() {
                      //set the name of type of the chart
                      //selectedTypeOfCharts used as an argument in switch function
                      selectedTypeOfCharts = typesOfCharts[index];
                    });
                  },
                  indicator: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topRight: radius,
                        topLeft: radius,
                        bottomRight: radius,
                        bottomLeft: radius,
                      )),
                      color: accentCustomColor),
                  controller: _typeOfChartController,
                  isScrollable: true,
                  //For Selected tab
                  labelStyle: TextStyle(fontSize: 14.0, color: Colors.white),
                  //For Un-selected Tabs
                  unselectedLabelStyle:
                      TextStyle(fontSize: 12.0, color: Colors.green),
                  //funtion to generate tabs
                  tabs: new List.generate(typesOfCharts.length, (index) {
                    return new Tab(
                      iconMargin: EdgeInsets.only(bottom: 3),
                      text: typesOfCharts[index].toUpperCase(),
                    );
                  }),
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          //Row for buttons
          TemperatureSetOfButtons(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
