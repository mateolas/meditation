import 'dart:io';
import 'package:archive_your_bill/api/bill_api.dart';
import 'package:archive_your_bill/model/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:archive_your_bill/model/hParameter.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

//screen to create/edit the bill
class BillForm extends StatefulWidget {
  final bool isUpdating;

  BillForm({@required this.isUpdating});

  @override
  _BillFormState createState() => _BillFormState();
}

class _BillFormState extends State<BillForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autovalidate = false;
  // ignore: avoid_init_to_null
  String selectedCategory = null;
  // ignore: avoid_init_to_null
  String selectedCurrency = null;
  String name;

  Hparameter _currentHparameter;

  DateTime _selectedDate = DateTime.now();
  DateTime _warrantyValidUntil;
  var itemWarrantyLengthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    HParameterNotifier billNotifier =
        Provider.of<HParameterNotifier>(context, listen: false);

    if (billNotifier.currentHParameter != null) {
      _currentHparameter = billNotifier.currentHParameter;
    } else {
      _currentHparameter = Hparameter();
    }
  }

  Widget _buildTemperatureField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Temperature'),
      autovalidate: _autovalidate,
      
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 16),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Temperature is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentHparameter.temperature = value;
      },
    );
  }

  Widget _buildWeightField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Weight'),
      autovalidate: _autovalidate,
      
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 16),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Weight is required';
        }

        return null;
      },
      onSaved: (String value) {
        _currentHparameter.weight = value;
      },
    );
  }

  _onBillUploaded(Hparameter bill) {
    HParameterNotifier billNotifier =
        Provider.of<HParameterNotifier>(context, listen: false);
    billNotifier.addBill(bill);
    Navigator.pop(context);
  }

  _saveBill() {
    print('saveBill Called');

    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

    uploadBill(_currentHparameter, _onBillUploaded);

    print("name: ${_currentHparameter.temperature}");
    print("category: ${_currentHparameter.weight}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff56ab2f),
                Color(0xffa8e063),
              ]),
        )),
        title: Text(
          widget.isUpdating ? "Add parameters" : "Create Bill",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: false,
          child: Column(
            children: <Widget>[
              SizedBox(height: 16),
              SizedBox(height: 16),
              //if there's no image file

              SizedBox(height: 26),
              _buildTemperatureField(),
              _buildWeightField(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //FocusScope.of(context).requestFocus(new FocusNode());
          //Navigator.of(context).pop();
          _saveBill();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}
