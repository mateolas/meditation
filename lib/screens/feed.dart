import 'package:archive_your_bill/api/bill_api.dart';
import 'package:archive_your_bill/model/colors.dart';
import 'package:archive_your_bill/model/temperatureChartData.dart';
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
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:archive_your_bill/model/globals.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive_your_bill/model/dateCheck.dart';
import 'package:archive_your_bill/model/hParameter.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with SingleTickerProviderStateMixin {
  List _resultsList = [];
  //BottomTab controller
  TabController _controller;
  //Index of selected BottomTab
  int _selectedIndex = 0;
  List tabNames = [
    'All',
    'Temperature',
    'Pulse',
    'Saturation',
    'Weight',
  ];

  @override
  void initState() {
    HParameterNotifier hParameterNotifier =
        Provider.of<HParameterNotifier>(context, listen: false);
    getHParameters(hParameterNotifier);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onTap(BuildContext context, Widget widget) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(),
          body: widget,
        ),
      ),
    );
  }

  //function to used in RefreshIndicator widget
  //swipe to refresh
  Future<void> _refreshList() async {
    HParameterNotifier billNotifier =
        Provider.of<HParameterNotifier>(context, listen: false);
    getHParameters(billNotifier);
  }

  Widget buildDayView() {
    return ButtonTheme(
      minWidth: 10.0,
      height: 20.0,
      child: FlatButton(
        color: Colors.blue,
        textColor: Colors.white,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        padding: EdgeInsets.all(0.0),
        splashColor: Colors.blueAccent,
        onPressed: () {
          /*...*/
        },
        child: Text(
          'DAY',
          style: TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    HParameterNotifier hParemterNotifier =
        Provider.of<HParameterNotifier>(context);

    print("1 Building Feed");
    print('2 Authnotifier ${authNotifier.user.displayName}');
    print(
        "3 BUILD RESULT LIST LENGTH: ${hParemterNotifier.hParameterList.length}");

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
                  ],
                ),
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
              Card(
                elevation: 12,
                child: Column(
                  children: [
                    Padding(
                      padding: new EdgeInsets.fromLTRB(6, 6, 6, 6),
                      child: SizedBox(
                        height: 304,
                        child: SimpleTimeSeriesChart.withSampleData(
                            hParemterNotifier),
                      ),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                          child: Row(
                            children: [
                              Text('Add'),
                              Text('   '),
                              Text('Delete'),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text(' '),
                              Text('View:'),
                              Text(' '),
                              buildDayView(),
                              Text(' '),
                              Text('WEEK'),
                              Text(' '),
                              Text('MONTH'),
                              Text(' '),
                              Text('YEAR'),
                              Text(' '),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: Text('DETAILS'),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                  ],
                ),
              ),
              //for(var item in hParemterNotifier.hParameterList ) Text(item.temperature)
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
                hParemterNotifier.currentHParameter = null;
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
