import 'package:flutter/material.dart';
import 'package:archive_your_bill/api/hParameter_api.dart';
import 'package:archive_your_bill/model/colors.dart';
import 'package:archive_your_bill/model/hParameter.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';

class TemperatureDetails extends StatefulWidget {
  TemperatureDetails();

  @override
  _TemperatureDetailsState createState() => _TemperatureDetailsState();
}

class _TemperatureDetailsState extends State<TemperatureDetails> {
  //Hparameter which will be "uploading"
  Hparameter _currentHparameter;
  //new decimal picker
  NumberPicker decimalNumberPicker;
  //default value of a decimal picker
  double _currentDoubleValue = 36.6;

  

  //calling initState function to get all temperature data
  @override
  void initState() {
    //initializing notifier to fetch data from firebase
    HParameterNotifier hParameterNotifier =
        Provider.of<HParameterNotifier>(context, listen: false);
    //fetching data from firebase
    getHParameters(hParameterNotifier);
    //setting default temperature time frame view for 'Day'

    super.initState();
  }

  //function to create table with temperature date and time values
  Widget createTable() {
    HParameterNotifier hParameterNotifier =
        Provider.of<HParameterNotifier>(context, listen: false);

    return DataTable(
      //columns data
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Nr',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Date',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Temperature value',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      //rows data
      rows: List<DataRow>.generate(
        hParameterNotifier.hParameterList.length,
        (index) => DataRow(
          cells: [
            DataCell(
              Text("${index+1}"),
            ),
            DataCell(
              Text("${DateFormat.MMMd().add_jm().format(hParameterNotifier.hParameterList[index].createdAt.toDate())}"),
            ),
            DataCell(
              Text("${hParameterNotifier.hParameterList[index].temperature}"),
            ),
          ],
        ),
      ),
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

    _currentHparameter.temperature = _currentDoubleValue.toString();

    uploadBill(_currentHparameter, _onBillUploaded);

    print("name: ${_currentHparameter.temperature}");
    print("category: ${_currentHparameter.weight}");
    print('form saved');
  }

  @override
  Widget build(BuildContext context) {
    HParameterNotifier hParemterNotifier =
        Provider.of<HParameterNotifier>(context);
    print(
        "3 BUILD RESULT LIST LENGTH IN DETAILS: ${hParemterNotifier.hParameterList.length}");
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: new Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 32),
              child: Text(
                'TEMPERATURE DETAILS',
                style: TextStyle(
                  fontSize: 24,
                  color: accentCustomColor,
                ),
              ),
            ),
          ),
          createTable(),
        ],
      ),
    );
  }
}
