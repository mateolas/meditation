import 'package:flutter/material.dart';
import 'package:health_parameters_tracker/api/hParameter_api.dart';
import 'package:health_parameters_tracker/model/hParameter.dart';
import 'package:health_parameters_tracker/notifier/bill_notifier.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';

class AddWeightParameter extends StatefulWidget {
  AddWeightParameter();

  @override
  _AddWeightParameter createState() => _AddWeightParameter();
}

class _AddWeightParameter extends State<AddWeightParameter> {
  //Hparameter which will be "uploading"
  Hparameter _currentHparameter;
  //new decimal picker
  NumberPicker decimalNumberPicker;
  //default value of a decimal picker
  double _initialWeightValue = 62;
  

  //calling initState function to initialize _currentHparameter
  @override
  void initState() {
    super.initState();
    HParameterNotifier hParameterNotifier =
        Provider.of<HParameterNotifier>(context, listen: false);

    //if last record is null, last record is an init value
    if(hParameterNotifier.hParameterList[0].weight == null){
      _initialWeightValue = 62; 
    //if last record isn't null, init value equals to last record
    } else {
      _initialWeightValue = double.parse(hParameterNotifier.hParameterList[0].weight);
    } 

    //initiate _currentHparameter
    _currentHparameter = Hparameter();
  }

  //settings of the NumberPicker
  void _initializeNumberPicker() {
    
    decimalNumberPicker = new NumberPicker.decimal(
      selectedTextStyle: TextStyle(color: Colors.purple, fontSize: 24),
      initialValue: _initialWeightValue,
      minValue: 0,
      maxValue: 500,
      decimalPlaces: 1,
      onChanged: (value) => setState(() {
        _initialWeightValue = value;
        _currentHparameter.weight = _initialWeightValue.toString();
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

    _currentHparameter.weight = _initialWeightValue.toString();

    uploadBill(_currentHparameter, _onBillUploaded);

    print("name: ${_currentHparameter.weight}");
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
              'Add weight',
              style: TextStyle(
                fontSize: 24,
                color: Colors.purple,
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
            "$_initialWeightValue" + " kg",
            style: TextStyle(color: Colors.purple),
          ),
        ),
        //Add button
        ButtonTheme(
          //widht - half of the screen
          minWidth: MediaQuery.of(context).size.width / 2,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.purple),
            ),
            child: Text(
              'ADD',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            color: Colors.purple,
            //After pressing button modal botton sheet will appear
            onPressed: () => _saveBill(),
          ),
        ),
      ],
    );
  }
}
