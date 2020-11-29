import 'package:archive_your_bill/api/bill_api.dart';
import 'package:archive_your_bill/model/colors.dart';
import 'package:archive_your_bill/notifier/auth_notifier.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:archive_your_bill/screens/bill_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:archive_your_bill/screens/detail.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'package:archive_your_bill/model/globals.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive_your_bill/model/dateCheck.dart';
import 'package:archive_your_bill/model/bill.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  List _resultsList = [];
  ScrollController _hideButtonController;
  var _isVisible;
  //BottomTab controller
  TabController _controller;
  //Index of selected BottomTab
  int _selectedIndex = 0;
  int _selectedIndexListView = 0;
  List tabNames = [
    'All',
    'Electronics',
    'Fashion',
    'Sports',
    'Books/Music/Culture',
    'Home',
    'Food',
    'Health',
    'Services',
    'Other'
  ];

  @override
  void initState() {
    _controller = TabController(length: tabNames.length, vsync: this);
    _controller.addListener(() {
      setState(() {
        BillNotifier billNotifier =
            Provider.of<BillNotifier>(context, listen: false);
        _selectedIndex = _controller.index;
        getBillsBasedOnCategory(billNotifier, _selectedIndex);
      });
      print("Selected Index: " + _controller.index.toString());
    });

    BillNotifier billNotifier =
        Provider.of<BillNotifier>(context, listen: false);
    getBills(billNotifier);
    _resultsList = billNotifier.billList;

    //setSearchResultsList(billNotifier);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //function wcich creates a second filtered list
  //bill notifier as a argument to get the list of the bills
  setSearchResultsList(billNotifier) {
    //list were filtered values will be kept
    var showResults = [];

    //if text field is not empty
    if (_searchController.text != "") {
      //search whole list from firebase
      for (var bill in billNotifier.billList) {
        var title = bill.nameShop.toLowerCase();
        var title2 = bill.nameItem.toLowerCase();
        //if typed by user value equals bill's nameShop or nameItem add bill to the filtered list - showResults
        if (title.contains(_searchController.text.toLowerCase()) ||
            title2.contains(_searchController.text.toLowerCase())) {
          showResults.add(bill);
        }
      }
      //if text field is empty copy all the items from list fetched from firebase to filtered list
    } else {
      showResults = billNotifier.billList;
    }
    //update the results
    setState(() {
      _resultsList = showResults;
    });
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
      String warrantyLength,
      String currencyItem}) async {
    //enable permission to write/read from internal memory
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final RenderBox box = context.findRenderObject();
    //message to be display in email sharing
    String message = """
    Hey ! 
    ${warrantyStart} at ${nameShop} you 
    
    bought ${nameItem} for ${itemPrice} ${currencyItem}.
    
    
    
    Thanks for using Archive your bill. 
    Your bill is save with us :).
    AYB team
    """;

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
        text: message,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  //function to used in RefreshIndicator widget
  //swipe to refresh
  Future<void> _refreshList() async {
    BillNotifier billNotifier =
        Provider.of<BillNotifier>(context, listen: false);
    getBills(billNotifier);
    //setSearchResultsList(billNotifier);
  }

  updateResults() {
    BillNotifier billNotifier =
        Provider.of<BillNotifier>(context, listen: true);
    _resultsList = billNotifier.billList;
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    BillNotifier billNotifier = Provider.of<BillNotifier>(context);
    //Color color = Colors.blue;

    //sets the search results
    setSearchResultsList(billNotifier);

    print("1 Building Feed");
    print('2 Authnotifier ${authNotifier.user.displayName}');
    print("3 BUILD RESULT LIST LENGTH: ${_resultsList.length}");
    print('4 isAllSelected ${isAllSelected}');

    return DefaultTabController(
      length: tabNames.length,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false, // hides default back button
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff56ab2f),
                      Color(0xffa8e063),
                    ]),
              ),
            ),
            title: Text(
              'Health parameters tracker',
              style: TextStyle(color: Colors.white),
            ), //Image.asset('lib/assets/images/logo.png', scale: 5),
            centerTitle: true,
            actions: <Widget>[
              // action button - logout
              FlatButton(
                onPressed: () => signout(authNotifier),
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 26.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  child: ListView.builder(
                    //to monitor direction of scrolling (up / down)
                    //and based on it show / hide the Floating action button
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          //after clicking setting up with notifier a current bill
                          billNotifier.currentBill = _resultsList[index];
                          _selectedIndexListView = index;
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BillDetail()))
                              .then((value) {});
                        },
                        child: Card(
                          elevation: 3,
                          margin: EdgeInsets.all(6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          shadowColor: primaryCustomColor,
                          //color: Colors.transparent,
                        ),
                      );
                    },
                    itemCount: _resultsList.length,
                  ),
                  onRefresh: _refreshList,
                ),
              ),
            ],
          ),
          bottomNavigationBar: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              new AnimatedCrossFade(
                firstChild: new Material(
                  color: Theme.of(context).primaryColor,
                  child: new TabBar(
                    controller: _controller,
                    isScrollable: true,
                    tabs: new List.generate(tabNames.length, (index) {
                      return new Tab(
                        text: tabNames[index].toUpperCase(),
                      );
                    }),
                  ),
                ),
                secondChild: new Container(),
                crossFadeState: CrossFadeState.showFirst,
                //? CrossFadeState.showFirst
                //: CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),

            //flag which is set depending on the scroll direction

            child: FloatingActionButton(
              onPressed: () {
                billNotifier.currentBill = null;
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return BillForm(
                      isUpdating: false,
                    );
                  }),
                );
              },
              child: Icon(Icons.add),
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
