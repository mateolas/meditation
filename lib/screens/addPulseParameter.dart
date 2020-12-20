import 'package:flutter/material.dart';
import 'package:health_parameters_tracker/api/hParameter_api.dart';
import 'package:health_parameters_tracker/model/hParameter.dart';
import 'package:health_parameters_tracker/notifier/bill_notifier.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';

class AddPulseParameter extends StatefulWidget {
  AddPulseParameter();

  @override
  _AddPulseParameter createState() => _AddPulseParameter();
}

class _AddPulseParameter extends State<AddPulseParameter> {
  //Hparameter which will be "uploading"
  Hparameter _currentHparameter;
  //new decimal picker
  NumberPicker decimalNumberPicker;
  //default value of a decimal picker
  int _currentPulseValue = 80;

  //calling initState function to initialize _currentHparameter
  @override
  void initState() {
    super.initState();
    //initiate _currentHparameter
    _currentHparameter = Hparameter();
  }

  //settings of the NumberPicker
  void _initializeNumberPicker() {
    
    decimalNumberPicker = new NumberPicker.integer(
      selectedTextStyle: TextStyle(color: Colors.red, fontSize: 24),
      initialValue: _currentPulseValue,
      minValue: 40,
      maxValue: 200,
      onChanged: (value) => setState(() {
        _currentPulseValue = value;
        _currentHparameter.pulse = _currentPulseValue.toString();
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

    _currentHparameter.pulse = _currentPulseValue.toString();

    uploadBill(_currentHparameter, _onBillUploaded);

    print("name: ${_currentHparameter.pulse}");
    print("category: ${_currentHparameter.weight}");
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
              'Add pulse',
              style: TextStyle(
                fontSize: 24,
                color: Colors.red,
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
            "$_currentPulseValue" + " BPM",
            style: TextStyle(color: Colors.red),
          ),
        ),
        //Add button
        ButtonTheme(
          //widht - half of the screen
          minWidth: MediaQuery.of(context).size.width / 2,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red),
            ),
            child: Text(
              'ADD',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            color: Colors.red,
            //After pressing button modal botton sheet will appear
            onPressed: () => _saveBill(),
          ),
        ),
      ],
    );
  }
}
