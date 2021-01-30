import 'package:health_parameters_tracker/api/hParameter_api.dart';
import 'package:health_parameters_tracker/notifier/auth_notifier.dart';
import 'package:health_parameters_tracker/notifier/bill_notifier.dart';
import 'package:health_parameters_tracker/notifier/units_notifier.dart';
import 'package:health_parameters_tracker/notifier/meditationSession_notifier.dart';
import 'package:health_parameters_tracker/widgets/sessionLength.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:health_parameters_tracker/screens/sideMenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with SingleTickerProviderStateMixin {
  //Name of screens to present for TabBar

  bool isStartMeditationButtonPressed;
  double meditateTime;
  var progressValue = 45;

  @override
  void initState() {
    isStartMeditationButtonPressed = false;
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
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context);

    final sliderSetTime = SleekCircularSlider(
      min: 0,
      max: 180,
      initialValue: 45,
      onChangeStart: (double startValue) {
        startValue = 30;
      },
      appearance: CircularSliderAppearance(
          startAngle: 150,
          angleRange: 355,
          customWidths: CustomSliderWidths(progressBarWidth: 16),
          size: 280,
          infoProperties: InfoProperties(
              mainLabelStyle: TextStyle(color: Colors.white, fontSize: 40),
              modifier: (double value) {
                var roundedValue = value.toInt();
                //one line function
                String twoDigits(int n) => n.toString().padLeft(2, "0");
                //changing int into Duration
                final d1 = Duration(minutes: roundedValue);

                String twoDigitMinutes = twoDigits(d1.inMinutes.remainder(200));
                return "$twoDigitMinutes min";
              }),
          customColors: CustomSliderColors(
            trackColor: Colors.white,
            progressBarColors: [
              Color(0xffFFE000),
              Color(0xffe65c00),
            ],
          )),
      onChange: (double value) {
        var arr = value.toString().split('.');
        int roundedValue = int.parse(arr[0]);

        meditationSessionNotifier.setLengthOfCurrentSession(roundedValue);
        print("I'm in end ...");

        print(value);
      },
    );

    final sliderCountTime = SleekCircularSlider(
        min: 0,
        max: 180,
        initialValue: 0,
        onChangeStart: (double startValue) {
          startValue = 0;
        },
        innerWidget: (double value) {
          print('Value from slider: $value');

          var arr = value.toString().split('.');

          int roundedValue = int.parse(arr[0]);
          print('Concatenaded value: $roundedValue');

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Countdown(
                duration: Duration(minutes: roundedValue),
                onFinish: () {
                  print('finished!');
                },
                builder: (BuildContext ctx, Duration remaining) {
                  String twoDigits(int n) => n.toString().padLeft(2, "0");
                  //changing int into Duration

                  String twoDigitMinutes =
                      twoDigits(remaining.inMinutes.remainder(200));
                  String twoDigitSeconds =
                      twoDigits(remaining.inSeconds.remainder(60));

                  return Text(
                    '${twoDigitMinutes}:${twoDigitSeconds}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  );
                },
              ),
            ],
          ); // use your custom widget inside the slider (gets a slider value from the callback)
        },
        appearance: CircularSliderAppearance(
            startAngle: 180,
            angleRange: 355,
            customWidths: CustomSliderWidths(progressBarWidth: 16),
            size: 280,
            infoProperties: InfoProperties(
                mainLabelStyle: TextStyle(color: Colors.white, fontSize: 40),
                modifier: (double value) {
                  var roundedValue = value.toInt();
                  //one line function
                  String twoDigits(int n) => n.toString().padLeft(2, "0");
                  //changing int into Duration
                  final d1 = Duration(minutes: roundedValue);

                  String twoDigitMinutes =
                      twoDigits(d1.inMinutes.remainder(200));
                  return "$twoDigitMinutes min";
                }),
            customColors: CustomSliderColors(
              trackColor: Colors.orange,
              progressBarColors: [
                Color(0xffFFE000),
                Color(0xffe65c00),
              ],
            )),
        onChangeEnd: (double value) {},
        onChange: (double value) {
          print(value);
        });

    print("1 Building Feed");

    print(
        "Length of session: ${meditationSessionNotifier.getLengthOfCurrentSession}");

    //print('2 Authnotifier ${authNotifier.user.displayName}');
    //print(
    //    "3 BUILD RESULT LIST LENGTH: ${hParemterNotifier.hParameterList.length}");

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
                    isStartMeditationButtonPressed == true
                        ? sliderCountTime
                        : sliderSetTime,
                    SizedBox(height: 30),

                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          isStartMeditationButtonPressed = true;
                        });
                      },
                      child: Text('Start', style: TextStyle(fontSize: 20)),
                    ),
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
