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

    WidgetsBinding.instance.addObserver(new LifecycleEventHandler(
        resumeCallBack: () async => refreshScreenAfterComingBackToApp()));

    //code to implement visibility of FloatingActionButton
    _isVisible = true;
    //scrollController
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          /* only set when the previous state is false
             * Less widget rebuilds 
             */
          print("**** ${_isVisible} up"); //Move IO away from setState
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            /* only set when the previous state is false
               * Less widget rebuilds 
               */
            print("**** ${_isVisible} down"); //Move IO away from setState
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });

    BillNotifier billNotifier =
        Provider.of<BillNotifier>(context, listen: false);
    getBills(billNotifier);
    _resultsList = billNotifier.billList;
    _searchController.addListener(_onSearchChanged);
    //setSearchResultsList(billNotifier);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged());
    _searchController.dispose();
    super.dispose();
  }

  void refreshScreenAfterComingBackToApp() {
    setState(() {});
  }

  Widget _isWarrantyValid(int index, List<Bill> listOfBills) {
    //the birthday's date
//  final birthday = DateTime(1967, 10, 12);
//  final date2 = DateTime.now();
//  final difference = date2.difference(birthday).inDays;

    // Here you can change your widget
    // each time the app resumed.
    var now = DateTime.now();

    // Is now time is before the warranty End
    // If it's true warranty is Valid
    if (DateTime(now.year, now.month, now.day)
        .isBefore(listOfBills[index].warrantyEnd.toDate())) {
      listOfBills[index].warrantyValid = "VALID";
      print(
          'Warranty nr ${index} valid inside function: ${listOfBills[index].warrantyValid}');
    }
    // Is now time is after the warranty End
    // If it's true warranty is Expired
    else if (DateTime(now.year, now.month, now.day)
        .isAfter(listOfBills[index].warrantyEnd.toDate())) {
      listOfBills[index].warrantyValid = "EXPIRED";
      print(
          'Warranty ${index} expired inside fucntion: ${listOfBills[index].warrantyValid}');
    }

    if (listOfBills[index].warrantyValid == "VALID") {
      return RichText(
        text: TextSpan(
            text: 'Warranty status: ',
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: ' ${listOfBills[index].warrantyValid}',
                style: TextStyle(color: Colors.green),
              )
            ]),
      );
    } else
      return RichText(
        text: TextSpan(
            text: 'Warranty status: ',
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: ' ${listOfBills[index].warrantyValid}',
                style: TextStyle(color: Colors.grey),
              )
            ]),
      );
  }

  _onSearchChanged() {
    BillNotifier billNotifier =
        Provider.of<BillNotifier>(context, listen: false);
    setSearchResultsList(billNotifier);
    //print(_searchController.text);
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

  //Search field widget
  Widget searchField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'Search in: ${tabNames[_selectedIndex]}',
          prefixIcon: Icon(Icons.search),
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(24.0),
            ),
          ),
        ),
      ),
    );
  }

  //function which draws Icon based on the chosen by user category
  categoryToIcon(String category) {
    switch (category) {
      case "Electronics":
        {
          return Icon(
            Icons.computer,
            size: 32,
            color: primaryCustomColor,
          );
        }
        break;

      case "Fashion":
        {
          return Icon(Icons.local_offer, size: 32, color: primaryCustomColor);
        }
        break;

      case "Sports":
        {
          return Icon(Icons.fitness_center,
              size: 32, color: primaryCustomColor);
        }
        break;

      case "Books/Music/Culture":
        {
          return Icon(Icons.format_quote, size: 32, color: primaryCustomColor);
        }
        break;

      case "Home":
        {
          return Icon(Icons.home, size: 32, color: primaryCustomColor);
        }
        break;

      case "Food":
        {
          return Icon(Icons.local_dining, size: 32, color: primaryCustomColor);
        }
        break;

      case "Health":
        {
          return Icon(Icons.local_hospital,
              size: 32, color: primaryCustomColor);
        }
        break;

      case "Services":
        {
          return Icon(Icons.build, size: 32, color: primaryCustomColor);
        }
        break;

      case "Other":
        {
          return Icon(Icons.receipt, size: 32, color: primaryCustomColor);
        }
        break;

      case "All":
        {
          return Text("ALL",
              style: TextStyle(color: primaryCustomColor, fontSize: 18));
        }
        break;
    }
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

  Widget noBillsYetText() {
    return Expanded(
      child: Container(
        //alignment: FractionalOffset.bottomCenter,
        child: Column(
          children: [
            Container(
              //color: Colors.yellow,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
                child:
                    Image.asset('lib/assets/images/empty box.png', scale: 10.5),
              ),
            ),
            isAllSelected
                ? Expanded(
                    child: Container(
                      //color: Colors.blue,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 40),
                          child: Image.asset('lib/assets/images/arrow.png',
                              scale: 2.7),
                        ),
                      ),
                    ),
                  )
                : Text(""),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
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
                      Color(0xffB1097C),
                      Color(0xff0947B1),
                    ]),
              ),
            ),
            title: Text(
              'Archive your bill',
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
              searchField(),
              billNotifier.billList.isEmpty
                  ? noBillsYetText()
                  : Expanded(
                      child: RefreshIndicator(
                        child: ListView.builder(
                          //to monitor direction of scrolling (up / down)
                          //and based on it show / hide the Floating action button
                          controller: _hideButtonController,
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
                                child: Container(
                                  height: 140,
                                  child: Center(
                                    child: Row(
                                      children: <Widget>[
                                        //Category Icon
                                        Container(
                                            padding: EdgeInsets.all(10),
                                            //color: Colors.blue,
                                            child: categoryToIcon(
                                                _resultsList[index].category)),
                                        //Item name and cost
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            //SHOP NAME
                                            Text(
                                              '${_resultsList[index].nameShop}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: primaryCustomColor,
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 6)),
                                            //ITEM NAME
                                            Text(
                                              '${_resultsList[index].nameItem} (${_resultsList[index].category})',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: accentCustomColor,
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 12)),
                                            //ITEM PRICE AND CURRENCY
                                            Row(
                                              children: [
                                                Text(
                                                    'Price: ${_resultsList[index].priceItem}',
                                                    style: TextStyle(
                                                        fontSize: 14)),
                                                Text(
                                                    ' ${_resultsList[index].currencyItem}',
                                                    style: TextStyle(
                                                        fontSize: 14)),
                                              ],
                                            ),
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 4)),
                                            //ITEM BOUGHT DATE
                                            Text(
                                              'Bought: ${DateFormat.yMMMd().format(_resultsList[index].warrantyStart.toDate())}',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 4)),
                                            //WARRANTY UNTIL
                                            // billNotifier.billList[index]
                                            //             .warrantyEnd ==
                                            //         null
                                            //     ? Text('')
                                            //     : Text(
                                            //         'Warranty until: ${DateFormat.yMMMd().format(_resultsList[index].warrantyEnd.toDate())}',
                                            //         style: TextStyle(
                                            //           fontSize: 14,
                                            //         ),
                                            //       ),
                                            // Padding(
                                            //     padding: EdgeInsets.fromLTRB(
                                            //         0, 0, 0, 4)),
                                            //WARRANTY VALID
                                            billNotifier.billList[index]
                                                        .warrantyValid ==
                                                    null
                                                ? Text('')
                                                : //Text('')
                                                _isWarrantyValid(
                                                    index, _resultsList),
                                            // Text(
                                            //   'Warranty status: ${_resultsList[index].warrantyValid}',
                                            //   style: TextStyle(
                                            //     fontSize: 14,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                  child: IconButton(
                                                    icon: Icon(Icons.edit),
                                                    color: Colors.grey,
                                                    onPressed: () {
                                                      billNotifier.currentBill =
                                                          _resultsList[index];
                                                      Navigator.of(context)
                                                          .push(
                                                        new MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                          return BillForm(
                                                            isUpdating: true,
                                                          );
                                                        }),
                                                      ).then(
                                                              (value) =>
                                                                  setState(
                                                                      () => {
                                                                            getBills(billNotifier)
                                                                          }));
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  child: IconButton(
                                                    icon: Icon(Icons.share),
                                                    //disabledColor:
                                                    //    Colors.yellow,
                                                    color: Colors.grey,
                                                    onPressed: () {
                                                      billNotifier.currentBill =
                                                          _resultsList[index];
                                                      _resultsList[index]
                                                                  .image ==
                                                              null
                                                          ? _resultsList[index]
                                                                  .image =
                                                              'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg'
                                                          : _resultsList[index]
                                                              .image;

                                                      saveAndShare(
                                                          nameShop:
                                                              _resultsList[index]
                                                                  .nameShop,
                                                          nameItem:
                                                              _resultsList[index]
                                                                  .nameItem,
                                                          itemPrice:
                                                              _resultsList[index]
                                                                  .priceItem,
                                                          warrantyStart:
                                                              DateFormat.yMMMd().format(
                                                                  _resultsList[index]
                                                                      .warrantyStart
                                                                      .toDate()),
                                                          warrantyEnd: DateFormat.yMMMd()
                                                              .format(_resultsList[index]
                                                                  .warrantyEnd
                                                                  .toDate()),
                                                          warrantyLength:
                                                              _resultsList[index]
                                                                  .warrantyLength,
                                                          url: _resultsList[
                                                                  index]
                                                              .image,
                                                          currencyItem:
                                                              _resultsList[index]
                                                                  .currencyItem);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
            child: Visibility(
              //flag which is set depending on the scroll direction
              visible: _isVisible,
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
      ),
    );
  }
}
