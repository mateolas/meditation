import 'package:health_parameters_tracker/api/hParameter_api.dart';
import 'package:health_parameters_tracker/notifier/auth_notifier.dart';
import 'package:health_parameters_tracker/notifier/bill_notifier.dart';
import 'package:health_parameters_tracker/notifier/units_notifier.dart';
import 'package:health_parameters_tracker/widgets/meditationTimeSlider.dart';

import 'package:health_parameters_tracker/screens/sideMenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with SingleTickerProviderStateMixin {
  //Name of screens to present for TabBar

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

  @protected
  @mustCallSuper
  void didChangeDependencies() {
    setState(() {
      UnitsNotifier unitsNotifier =
          Provider.of<UnitsNotifier>(context, listen: true);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    HParameterNotifier hParemterNotifier =
        Provider.of<HParameterNotifier>(context);

    print("1 Building Feed");
    //print('2 Authnotifier ${authNotifier.user.displayName}');
    print(
        "3 BUILD RESULT LIST LENGTH: ${hParemterNotifier.hParameterList.length}");

    return Scaffold(
      //background color behing the appbar
      extendBodyBehindAppBar: true,
      drawer: SideMenu(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true, // hides default back button
        backgroundColor: Colors.transparent,
        title: Text(
          'Meditation',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          // action button - logout
          FlatButton(
            onPressed: () => signOutGoogle(authNotifier),
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
              size: 26.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //card to hold chart + buttons
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xffe65c00),
                        Color(0xffFFE000),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    MeditationTimeSlider(),
                    // Container(
                    //   color: Colors.blue,
                    //   child: Text('Test'),
                    // ),
                  ],
                ),
              ],
            ),

            //for(var item in hParemterNotifier.hParameterList ) Text(item.temperature)
          ],
        ),
      ),
    );
  }
}
