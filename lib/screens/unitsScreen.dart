/// Flutter code sample for Radio

// Here is an example of Radio widgets wrapped in ListTiles, which is similar
// to what you could get with the RadioListTile widget.
//
// The currently selected character is passed into `groupValue`, which is
// maintained by the example's `State`. In this case, the first `Radio`
// will start off selected because `_character` is initialized to
// `SingingCharacter.lafayette`.
//
// If the second radio button is pressed, the example's state is updated
// with `setState`, updating `_character` to `SingingCharacter.jefferson`.
// This causes the buttons to rebuild with the updated `groupValue`, and
// therefore the selection of the second button.
//
// Requires one of its ancestors to be a [Material] widget.

import 'package:flutter/material.dart';
import 'package:health_parameters_tracker/notifier/units_notifier.dart';
import 'package:provider/provider.dart';

enum TemperatureUnits { celsius, fahrenheit }

/// This is the stateful widget that the main application instantiates.
class UnitsScreen extends StatefulWidget {
  UnitsScreen({Key key}) : super(key: key);

  @override
  _UnitsScreenState createState() => _UnitsScreenState();

  /// This is the private State class that goes with MyStatefulWidget.
}

class _UnitsScreenState extends State<UnitsScreen> {
  TemperatureUnits _temperatureUnits = TemperatureUnits.celsius;



  @override
  void initState() {
    
    //initializing notifier to fetch data from firebase
    UnitsNotifier unitsNotifier =
        Provider.of<UnitsNotifier>(context, listen: false);
    super.initState();
  }

  Widget build(BuildContext context) {
    UnitsNotifier unitsNotifier =
        Provider.of<UnitsNotifier>(context, listen: false);

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
              value: TemperatureUnits.celsius,
              groupValue: _temperatureUnits,
              onChanged: (TemperatureUnits value) {
                setState(() {
                  _temperatureUnits = value;
                  UnitsNotifier unitsNotifier =
                      Provider.of<UnitsNotifier>(context, listen: false);
                  unitsNotifier.setTemperatureUnitToCelsius();
                  print('Celsis boolean: ${unitsNotifier.getIsCelsius}');
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
              value: TemperatureUnits.fahrenheit,
              groupValue: _temperatureUnits,
              onChanged: (TemperatureUnits value) {
                setState(() {
                  _temperatureUnits = value;
                  UnitsNotifier unitsNotifier =
                      Provider.of<UnitsNotifier>(context, listen: false);
                  unitsNotifier.setTemperatureUnitToFahrenheit();
                  print('Celsis boolean: ${unitsNotifier.getIsCelsius}');
                  print('Fahrenheit boolean: ${unitsNotifier.getIsFahrenheit}');
                });
              },
            ),
          ),
          Divider(),
          // Container(
          //   padding: EdgeInsets.fromLTRB(24, 12, 0, 0),
          //   child: Text(
          //     'Weight units:',
          //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //   ),
          // ),
          // ListTile(
          //   title: const Text('Kilograms (kg)', style: TextStyle(fontSize: 16)),
          //   leading: Radio(
          //     visualDensity: VisualDensity.compact,
          //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //     value: TemperatureUnits.celsius,
          //     groupValue: _temperatureUnits,
          //     onChanged: (TemperatureUnits value) {
          //       setState(() {
          //         _temperatureUnits = value;
          //       });
          //     },
          //   ),
          // ),
          // ListTile(
          //   title: const Text('Pounds (lbs)'),
          //   leading: Radio(
          //     visualDensity: VisualDensity.compact,
          //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //     value: TemperatureUnits.fahrenheit,
          //     groupValue: _temperatureUnits,
          //     onChanged: (TemperatureUnits value) {
          //       setState(() {
          //         _temperatureUnits = value;
          //       });
          //     },
          //   ),
          // ),
          Divider(),
        ],
      ),
    );
  }
}
