import 'package:flutter/material.dart';
import 'package:archive_your_bill/api/hParameter_api.dart';
import 'package:archive_your_bill/model/colors.dart';
import 'package:archive_your_bill/model/hParameter.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';

class SaturationDetails extends StatefulWidget {
  SaturationDetails();

  @override
  _SaturationDetailsState createState() => _SaturationDetailsState();
}

class _SaturationDetailsState extends State<SaturationDetails> {
  //new decimal picker
  NumberPicker decimalNumberPicker;

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

    //Two lists and for loop to get list without null values
    //To get non null temperature values
    List<String> listWithNoEmptyRecordsSaturationValues = [];
    //To get corresponding to non null temperature values Date values
    List<DateTime> listWithNoEmptyRecordsDateTimeValues = [];
    //Loop through the hParameter list and add to two new lists non null temperature values
    for (int i = 0; i < hParameterNotifier.hParameterList.length; i++) {
      if (hParameterNotifier.hParameterList[i].saturation != null) {
        listWithNoEmptyRecordsSaturationValues.add(hParameterNotifier.hParameterList[i].saturation);
        listWithNoEmptyRecordsDateTimeValues.add(hParameterNotifier.hParameterList[i].createdAt.toDate());
      }
    }

    return DataTable(
      //columns data
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Nr',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Date',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Pulse value',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      //rows data
      rows: List<DataRow>.generate(
        listWithNoEmptyRecordsSaturationValues.length,
        (index) => DataRow(
          cells: [
            DataCell(
              Text("${index + 1}"),
            ),
            DataCell(
              Text(
                  "${DateFormat.MMMd().add_jm().format(listWithNoEmptyRecordsDateTimeValues[index])}"),
            ),
            DataCell(
              Text("${listWithNoEmptyRecordsSaturationValues[index]}"),
            ),
          ],
        ),
      ),
    );
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
                'SATURATION DETAILS',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blue,
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
