import 'package:archive_your_bill/api/bill_api.dart';
import 'package:archive_your_bill/model/colors.dart';
import 'package:archive_your_bill/screens/bill_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:archive_your_bill/model/bill.dart';
import 'package:intl/intl.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';

import 'dart:io';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class BillDetail extends StatefulWidget {
  @override
  _BillDetailState createState() => _BillDetailState();
}

class _BillDetailState extends State<BillDetail> {
  @override
  Widget build(BuildContext context) {
    BillNotifier billNotifier = Provider.of<BillNotifier>(context);

    _onBillDeleted(Hparameter bill) {
      Navigator.pop(context);
      billNotifier.deleteBill(bill);
    }

    //function to get image from url, save it and share

    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      Widget continueButton = FlatButton(
        child: Text("Yes"),
        onPressed: () {
          Navigator.pop(context);
          deleteBill(billNotifier.currentBill, _onBillDeleted);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Delete Bill"),
        content: Text("Would you like to delete this bill ? (no undo)"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffB1097C),
                Color(0xff0947B1),
              ]),
        )),
        title: Text(billNotifier.currentBill.temperature),
      ),
      body: SingleChildScrollView(
        child: FloatingActionButton(
          heroTag: 'button2',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return BillForm(
                  isUpdating: true,
                );
              }),
            ).then((value) => setState(() => {getBills(billNotifier)}));
          },
          child: Icon(Icons.edit),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
