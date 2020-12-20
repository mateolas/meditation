import 'package:flutter/material.dart';
import 'package:health_parameters_tracker/api/hParameter_api.dart';
import 'package:health_parameters_tracker/notifier/bill_notifier.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';

class WeightDetails extends StatefulWidget {
  WeightDetails();

  @override
  _WeightDetailsState createState() => _WeightDetailsState();
}

class _WeightDetailsState extends State<WeightDetails> {
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
    List<String> listWithNoEmptyRecordsWeightValues = [];
    //To get corresponding to non null temperature values Date values
    List<DateTime> listWithNoEmptyRecordsDateTimeValues = [];
    //Loop through the hParameter list and add to two new lists non null temperature values
    for (int i = 0; i < hParameterNotifier.hParameterList.length; i++) {
      if (hParameterNotifier.hParameterList[i].weight != null) {
        listWithNoEmptyRecordsWeightValues.add(hParameterNotifier.hParameterList[i].weight);
        listWithNoEmptyRecordsDateTimeValues.add(hParameterNotifier.hParameterList[i].createdAt.toDate());
      }
    }

    return DataTable(
      //columns data
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Nr',
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Date',
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Weight value',
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      //rows data
      rows: List<DataRow>.generate(
        listWithNoEmptyRecordsWeightValues.length,
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
              Text("${listWithNoEmptyRecordsWeightValues[index]} kg"),
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
                'WEIGHT DETAILS',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.purple,
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
