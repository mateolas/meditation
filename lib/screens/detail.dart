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

    _onBillDeleted(Bill bill) {
      Navigator.pop(context);
      billNotifier.deleteBill(bill);
    }

    //function to get image from url, save it and share
    Future<Null> saveAndShare(
        {String url,
        String nameShop,
        String nameItem,
        String category,
        String itemPrice,
        String warrantyStart,
        String warrantyEnd,
        String warrantyLength}) async {
      //enable permission to write/read from internal memory
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      if (billNotifier.currentBill.image == null) {
        url =
            "https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg";
      }

      final RenderBox box = context.findRenderObject();

      //list of imagePaths
      List<String> imagePaths = [];
      var response = await get(url);
      //get the directory of external storage
      final documentDirectory = (await getExternalStorageDirectory()).path;
      //create empty file
      File imgFile = new File('$documentDirectory/flutter.png');
      //"copy" file from url to created empty file
      imgFile.writeAsBytesSync(response.bodyBytes);
      //add to list of paths path of created file
      imagePaths.add(imgFile.path);
      //share function
      Share.shareFiles(imagePaths,
          subject: 'Bill from ${nameShop} bought at ${warrantyStart}',
          text:
              'Hey! Just sending you a picture of a bill from ${nameShop} where ${warrantyStart} you bought ${nameItem}. Have a great day ! Archive Your Bill Team',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }

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
        title: Text(billNotifier.currentBill.nameShop),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  //Stack to enable put image, indicator and zoom icon at the top of each other
                  Stack(
                    children: [
                      Card(
                        elevation: 10,
                        margin: EdgeInsets.all(0),
                        child: GestureDetector(
                            child: Image.network(
                              billNotifier.currentBill.image != null
                                  ? billNotifier.currentBill.image
                                  : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                              width: MediaQuery.of(context).size.width,
                              height: 250,
                              fit: BoxFit.fitWidth,
                              //loadingBuilder to show indicator while loading the image
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  //indicator wrapped in container to set the width 250 and be "centered" with the image
                                  child: Container(
                                    height: 250,
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: CircularProgressIndicator(
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                            onTap: () {
                              if (billNotifier.currentBill.image == null) {
                                //'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg') {
                              } else {
                                print(
                                    "IMAGE STRING ${billNotifier.currentBill.image}");
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return Scaffold(
                                    appBar: new AppBar(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0.0,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    //Below are used two 3rd party Classes (packages):
                                    //CachedNetworkImage and PhotoView
                                    //CachedNetworkImage - to keep in cache memory internet pictures
                                    //PhotoView - to have possibility to zoom in/out the pictures
                                    body: CachedNetworkImage(
                                      imageUrl: billNotifier.currentBill.image,
                                      imageBuilder: (context, imageProvider) =>
                                          PhotoView(
                                        imageProvider: imageProvider,
                                      ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                    //Share icon on the picture
                                    floatingActionButton: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          height: 46.0,
                                          width: 46.0,
                                          child: FittedBox(
                                            child: FloatingActionButton(
                                              heroTag: 'button1',
                                              onPressed: () {
                                                saveAndShare(
                                                    nameShop: billNotifier
                                                        .currentBill.nameShop,
                                                    nameItem: billNotifier
                                                        .currentBill.nameItem,
                                                    itemPrice: billNotifier
                                                        .currentBill.priceItem,
                                                    warrantyStart:
                                                        DateFormat.yMMMd()
                                                            .format(billNotifier
                                                                .currentBill
                                                                .warrantyStart
                                                                .toDate()),
                                                    warrantyEnd: DateFormat.yMMMd()
                                                        .format(billNotifier
                                                            .currentBill
                                                            .warrantyEnd
                                                            .toDate()),
                                                    warrantyLength: billNotifier
                                                        .currentBill
                                                        .warrantyLength,
                                                    url: billNotifier
                                                        .currentBill.image);
                                              },
                                              child: Icon(Icons.share),
                                              foregroundColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  // PhotoView(
                                  //   //CachedNetworkImageProviders enables to cache the images from web
                                  //   imageProvider: CachedNetworkImageProvider(

                                  //       billNotifier.currentBill.image),
                                  // );

                                  //OnlyImageScreen(
                                  // url: billNotifier.currentBill.image,
                                  //);
                                }));
                              }
                            }),
                      ),
                      billNotifier.currentBill.image != null
                          ? Container(
                              height: 250,
                              alignment: AlignmentDirectional(0.95, 0.9),
                              child: Icon(Icons.search,
                                  size: 35, color: accentCustomColor))
                          : Text("")
                    ],
                  ),
                  SizedBox(height: 24),
                  //SHOP NAME
                  Text(
                    billNotifier.currentBill.nameShop,
                    style: TextStyle(
                      color: primaryCustomColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(height: 12),
                  //ITEM NAME
                  Text(
                    '${billNotifier.currentBill.nameItem}',
                    style: TextStyle(
                      fontSize: 24,
                      color: accentCustomColor,
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: RichText(
                    text: TextSpan(
                        text: 'Category: ',
                        style:
                            TextStyle(color: accentCustomColor, fontSize: 18),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' ${billNotifier.currentBill.category}',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          )
                        ]),
                  ),
                ),
                SizedBox(height: 10),
                //PRICE AND CURRENCY
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: Container(
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: 'Item price: ',
                              style: TextStyle(
                                  color: accentCustomColor, fontSize: 18),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      ' ${billNotifier.currentBill.priceItem} ${billNotifier.currentBill.currencyItem}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                //BOUGHT
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: Container(
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: 'Bought ',
                              style: TextStyle(
                                  color: accentCustomColor, fontSize: 18),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      ' ${DateFormat.yMMMd().format(billNotifier.currentBill.warrantyStart.toDate())}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                //WARRANTY UNTIL
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: billNotifier.currentBill.warrantyEnd == null
                      ? Text('')
                      : Container(
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: 'Warranty until: ',
                                    style: TextStyle(
                                        color: accentCustomColor, fontSize: 18),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            ' ${DateFormat.yMMMd().format(billNotifier.currentBill.warrantyEnd.toDate())}',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        ),
                ),
                SizedBox(height: 10),
                //WARRANTY LENGTH
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: billNotifier.currentBill.warrantyLength.isEmpty
                      ? Text('')
                      : Container(
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: 'Warranty length: ',
                                    style: TextStyle(
                                        color: accentCustomColor, fontSize: 18),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            ' ${billNotifier.currentBill.warrantyLength} months',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 46.0,
            width: 46.0,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: 'button1',
                onPressed: () {
                  saveAndShare(
                      nameShop: billNotifier.currentBill.nameShop,
                      nameItem: billNotifier.currentBill.nameItem,
                      itemPrice: billNotifier.currentBill.priceItem,
                      warrantyStart: DateFormat.yMMMd().format(
                          billNotifier.currentBill.warrantyStart.toDate()),
                      warrantyEnd: DateFormat.yMMMd().format(
                          billNotifier.currentBill.warrantyEnd.toDate()),
                      warrantyLength: billNotifier.currentBill.warrantyLength,
                      url: billNotifier.currentBill.image);
                },
                child: Icon(Icons.share),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 46.0,
            width: 46.0,
            child: FittedBox(
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
          ),
          SizedBox(height: 10),
          Container(
            height: 46.0,
            width: 46.0,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: 'button3',
                onPressed: () => showAlertDialog(context),
                //deleteBill(billNotifier.currentBill, _onBillDeleted),
                child: Icon(Icons.delete),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
