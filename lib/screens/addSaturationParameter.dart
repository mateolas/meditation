import 'package:flutter/material.dart';
import 'package:archive_your_bill/api/hParameter_api.dart';
import 'package:archive_your_bill/model/colors.dart';
import 'package:archive_your_bill/model/hParameter.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';

class AddSaturationParameter extends StatefulWidget {
  AddSaturationParameter();

  @override
  _AddSaturationParameter createState() => _AddSaturationParameter();
}

class _AddSaturationParameter extends State<AddSaturationParameter> {
  //Hparameter which will be "uploading"
  Hparameter _currentHparameter;
  //new decimal picker
  NumberPicker decimalNumberPicker;
  //default value of a decimal picker
  int _currentSaturationValue = 99;

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
      selectedTextStyle: TextStyle(color: Colors.blue, fontSize: 24),
      initialValue: _currentSaturationValue,
      minValue: 86,
      maxValue: 100,
      onChanged: (value) => setState(() {
        _currentSaturationValue = value;
        _currentHparameter.pulse = _currentSaturationValue.toString();
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

    _currentHparameter.saturation = _currentSaturationValue.toString();

    uploadBill(_currentHparameter, _onBillUploaded);

    print("name: ${_currentHparameter.saturation}");
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
              'Add saturation',
              style: TextStyle(
                fontSize: 24,
                color: Colors.blue,
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
            "$_currentSaturationValue" + " SpO\u2082 %",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        //Add button
        ButtonTheme(
          //widht - half of the screen
          minWidth: MediaQuery.of(context).size.width / 2,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.blue),
            ),
            child: Text(
              'ADD',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            color: Colors.blue,
            //After pressing button modal botton sheet will appear
            onPressed: () => _saveBill(),
          ),
        ),
      ],
    );
  }
}
