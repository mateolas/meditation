import 'package:flutter/material.dart';
import 'package:health_parameters_tracker/api/hParameter_api.dart';
import 'package:health_parameters_tracker/model/colors.dart';
import 'package:health_parameters_tracker/model/hParameter.dart';
import 'package:health_parameters_tracker/notifier/bill_notifier.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';

class AddFahrenheitTemperatureParameter extends StatefulWidget {
  AddFahrenheitTemperatureParameter();

  @override
  _AddFahrenheitTemperatureParameter createState() => _AddFahrenheitTemperatureParameter();
}

class _AddFahrenheitTemperatureParameter extends State<AddFahrenheitTemperatureParameter> {
  //Hparameter which will be "uploading"
  Hparameter _currentHparameter;
  //new decimal picker
  NumberPicker decimalNumberPicker;
  //default value of a decimal picker
  double _currentDoubleValue = 93;

  //calling initState function to initialize _currentHparameter
  @override
  void initState() {
    super.initState();
    //initiate _currentHparameter
    _currentHparameter = Hparameter();
  }

  //settings of the NumberPicker
  void _initializeNumberPicker() {
    decimalNumberPicker = new NumberPicker.decimal(
      initialValue: _currentDoubleValue,
      minValue: 93,
      maxValue: 107,
      decimalPlaces: 1,
      onChanged: (value) => setState(() {
        _currentDoubleValue = value;
        _currentHparameter.temperature = _currentDoubleValue.toString();
      }),
    );
  }

  //funtion to add _currenthParameter to the list of hParameters
  _onBillUploaded(Hparameter hParameter) {
    HParameterNotifier hParameterNotifier =
        Provider.of<HParameterNotifier>(context, listen: false);
    hParameterNotifier.addBill(hParameter);
    Navigator.pop(context);
  }

  //function to upload _currentHparameter to firebase
  _saveBill() {
    print('saveBill Called');

    //value in Fahrenheit
    _currentHparameter.temperatureFahrenheit = _currentDoubleValue.toString();
    //calculate to Celsius
    _currentHparameter.temperature = ((double.parse(_currentHparameter.temperatureFahrenheit)-32)/1.8).toString();


    uploadBill(_currentHparameter, _onBillUploaded);

    print("name: ${_currentHparameter.temperatureFahrenheit}");
    print('form saved');
  }

  @override
  Widget build(BuildContext context) {
    _initializeNumberPicker();
    

    return Column(
      children: [
        Container(
          child: new Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 32),
            child: Text(
              'Add temperature',
              style: TextStyle(
                fontSize: 24,
                color: accentCustomColor,
              ),
            ),
          ),
        ),
        //NumberPicker widget
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
          child: decimalNumberPicker,
        ),
        //temperature text below the number picker
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 49),
          child: Text(
            "$_currentDoubleValue" + " \u2103",
            style: TextStyle(color: accentCustomColor),
          ),
        ),
        //Add button
        ButtonTheme(
          //widht - half of the screen
          minWidth: MediaQuery.of(context).size.width / 2,
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
            onPressed: () => _saveBill(),
          ),
        ),
      ],
    );
  }
}
