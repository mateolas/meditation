import 'package:flutter/material.dart';
import 'package:health_parameters_tracker/notifier/units_notifier.dart';
import 'package:provider/provider.dart';

//enum values to "name" the different radio buttons (just like "one", "two" etc. )
enum TemperatureUnits { celsius, fahrenheit }
enum WeightUnits { kilograms, pounds }

/// This is the stateful widget that the main application instantiates.
class UnitsScreen extends StatefulWidget {
  UnitsScreen({Key key}) : super(key: key);

  @override
  _UnitsScreenState createState() => _UnitsScreenState();

  /// This is the private State class that goes with MyStatefulWidget.
}

class _UnitsScreenState extends State<UnitsScreen> {
  var _pickedTemperatureUnitsRadioValue;
  var _pickedWeightUnitsRadioValue;

  @override
  void initState() {
    //init state with unitsNotifier
    UnitsNotifier unitsNotifier =
        Provider.of<UnitsNotifier>(context, listen: false);

    //
    //TEMPERATURE UNIT
    //
    //check if unitsNotifier is null
    //if unitsNotifier is null, set default value to celsius values
    if (unitsNotifier.getIsCelsius == null &&
        unitsNotifier.getIsFahrenheit == null) {
      _pickedTemperatureUnitsRadioValue = TemperatureUnits.celsius;
    }
    //if unitsNotifier is not empty, check if celsius is true or fahrenheit is true
    else {
      print("i'm in if without nulls");
      if (unitsNotifier.getIsCelsius == true) {
        _pickedTemperatureUnitsRadioValue = TemperatureUnits.celsius;
      }
      if (unitsNotifier.getIsFahrenheit == true) {
        _pickedTemperatureUnitsRadioValue = TemperatureUnits.fahrenheit;
      }
    }

    //
    //WEIGHT UNIT
    //
    //check if unitsNotifier is null
    //if unitsNotifier is null, set default value to celsius values
    if (unitsNotifier.getIsKilogram == null &&
        unitsNotifier.getIsPound == null) {
      _pickedWeightUnitsRadioValue = WeightUnits.kilograms;
    }
    //if unitsNotifier is not empty, check if celsius is true or fahrenheit is true
    else {
      print("i'm in if without nulls");
      if (unitsNotifier.getIsKilogram == true) {
        _pickedWeightUnitsRadioValue = WeightUnits.kilograms;
      }
      if (unitsNotifier.getIsPound == true) {
        _pickedWeightUnitsRadioValue = WeightUnits.pounds;
      }
    }

    //for debug puproses
    print('Init getCelsius value: ${unitsNotifier.getIsCelsius}');
    print('Init getFahrenheit value: ${unitsNotifier.getIsFahrenheit}');
    super.initState();
  }

  Widget build(BuildContext context) {
    UnitsNotifier unitsNotifier =
        Provider.of<UnitsNotifier>(context, listen: false);

    print('BUILD Celsius boolean: ${unitsNotifier.getIsCelsius}');
    print('BUILD Fahrenheit boolean: ${unitsNotifier.getIsFahrenheit}');
    print('BUILD Kilograms boolean: ${unitsNotifier.getIsKilogram}');
    print('BUILD Pounds boolean: ${unitsNotifier.getIsPound}');
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
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
          'Units',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(24, 12, 0, 0),
            child: Text(
              'Temperature units:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title:
                const Text('Celsius (\u2103)', style: TextStyle(fontSize: 16)),
            leading: Radio(
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //value - "label" of a particular radio button
              value: TemperatureUnits.celsius,
              //groupValue - output value of a particular group of radio buttons
              groupValue: _pickedTemperatureUnitsRadioValue,
              onChanged: (value) {
                setState(() {
                  //to mark proper radio button
                  _pickedTemperatureUnitsRadioValue = value;
                  UnitsNotifier unitsNotifier =
                      Provider.of<UnitsNotifier>(context, listen: false);
                  //updating the Notifier state
                  unitsNotifier.setTemperatureUnitToCelsius();
                  print('Celsius boolean: ${unitsNotifier.getIsCelsius}');
                  print('Fahrenheit boolean: ${unitsNotifier.getIsFahrenheit}');
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Fahrenheit (\u2109)'),
            leading: Radio(
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //value - "label" of a particular radio button
              value: TemperatureUnits.fahrenheit,
              //groupValue - output value of a particular group of radio buttons
              groupValue: _pickedTemperatureUnitsRadioValue,
              onChanged: (value) {
                setState(() {
                  //to mark proper radio button
                  _pickedTemperatureUnitsRadioValue = value;
                  UnitsNotifier unitsNotifier =
                      Provider.of<UnitsNotifier>(context, listen: false);
                  //updating the Notifier state
                  unitsNotifier.setTemperatureUnitToFahrenheit();
                  print('Celsius boolean: ${unitsNotifier.getIsCelsius}');
                  print('Fahrenheit boolean: ${unitsNotifier.getIsFahrenheit}');
                });
              },
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.fromLTRB(24, 12, 0, 0),
            child: Text(
              'Weight units:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text('Kilograms (kg)', style: TextStyle(fontSize: 16)),
            leading: Radio(
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //value - "label" of a particular radio button
              value: WeightUnits.kilograms,
              //groupValue - output value of a particular group of radio buttons
              groupValue: _pickedWeightUnitsRadioValue,
              onChanged: (value) {
                setState(() {
                  //to mark proper radio button
                  _pickedWeightUnitsRadioValue = value;
                  UnitsNotifier unitsNotifier =
                      Provider.of<UnitsNotifier>(context, listen: false);
                  //updating the Notifier state
                  unitsNotifier.setWeightUnitToKilograms();
                  print('Kilograms boolean: ${unitsNotifier.getIsKilogram}');
                  print('Pounds boolean: ${unitsNotifier.getIsPound}');
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Pounds (lbs)'),
            leading: Radio(
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //value - "label" of a particular radio button
              value: WeightUnits.pounds,
              //groupValue - output value of a particular group of radio buttons
              groupValue: _pickedWeightUnitsRadioValue,
              onChanged: (value) {
                setState(() {
                  //to mark proper radio button
                  _pickedWeightUnitsRadioValue = value;
                  UnitsNotifier unitsNotifier =
                      Provider.of<UnitsNotifier>(context, listen: false);
                  //updating the Notifier state
                  unitsNotifier.setWeightUnitToPounds();
                  print('Kilograms boolean: ${unitsNotifier.getIsKilogram}');
                  print('Pounds boolean: ${unitsNotifier.getIsPound}');
                });
              },
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
