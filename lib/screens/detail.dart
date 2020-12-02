// import 'package:archive_your_bill/api/bill_api.dart';
// import 'package:archive_your_bill/model/colors.dart';
// import 'package:archive_your_bill/screens/bill_form.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:archive_your_bill/model/hParameter.dart';
// import 'package:intl/intl.dart';
// import 'package:archive_your_bill/notifier/bill_notifier.dart';

// import 'dart:io';
// import 'package:share/share.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:http/http.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:photo_view/photo_view.dart';

// class BillDetail extends StatefulWidget {
//   @override
//   _BillDetailState createState() => _BillDetailState();
// }

// class _BillDetailState extends State<BillDetail> {
//   @override
//   Widget build(BuildContext context) {
//     HParameterNotifier billNotifier = Provider.of<HParameterNotifier>(context);
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//             decoration: BoxDecoration(
//           gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xff56ab2f),
//                 Color(0xffa8e063),
//               ]),
//         )),
//         title: Text(billNotifier.currentHParameter.temperature),
//       ),
//       body: SingleChildScrollView(
//         child: FloatingActionButton(
//           heroTag: 'button1',
//           onPressed: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (BuildContext context) {
//                 return BillForm(
//                   isUpdating: true,
//                 );
//               }),
//             ).then((value) => setState(() => {getHParameters(billNotifier)}));
//           },
//         ),
//       ),
//     );
//   }
// }
