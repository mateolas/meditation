import 'package:health_parameters_tracker/api/hParameter_api.dart';
import 'package:health_parameters_tracker/notifier/auth_notifier.dart';
import 'package:health_parameters_tracker/notifier/bill_notifier.dart';
import 'package:health_parameters_tracker/notifier/units_notifier.dart';
import 'package:health_parameters_tracker/notifier/meditationSession_notifier.dart';

import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:health_parameters_tracker/screens/sideMenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class MeditationSessionScreen extends StatefulWidget {
  @override
  _MeditationSessionScreenState createState() =>
      _MeditationSessionScreenState();
}

class _MeditationSessionScreenState extends State<MeditationSessionScreen> {
  //if button "Start meditation" was pressed or not
  bool isStartMeditationButtonPressed;
  //variable to hold value of how long was meditation session
  double meditateTime;
  //Controller of a page swipping. Manages swipe detection and provides animation.
  final pageController = PageController(initialPage: 0);
  //if button "Vibrations" is pressed
  bool isVibrationButtonPressed;
  //if button "Sound" is pressed
  bool isPlaySoundButtonPressed;

  @override
  void initState() {
    //on initalization of the app button "Start session" is not pressed
    isStartMeditationButtonPressed = false;
    //on initalization of the app button "Vibration" is not pressed
    isVibrationButtonPressed = false;
    //on initalization of the app button "Vibration" is not pressed
    isPlaySoundButtonPressed = false;
    //initializing notifier to fetch data from firebase
    //HParameterNotifier hParameterNotifier =
    //    Provider.of<HParameterNotifier>(context, listen: false);

    //fetching data from firebase
    //getHParameters(hParameterNotifier);
    //setting default temperature time frame view for 'Day'

    super.initState();
  }

  @protected
  @mustCallSuper
  void didChangeDependencies() {
    setState(() {
      //UnitsNotifier unitsNotifier =
      //  Provider.of<UnitsNotifier>(context, listen: true);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  //function to show dialog which confirms that session was completed
  //change isStartMeditationButtonPressed to false (to show "Set time" slider)
  //after confirming it, data about session is sent to Firebase
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Session complete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Great job ! Your session is complete'),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: ButtonTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                  //width: double.infinity/2,
                  child: RaisedButton(
                      elevation: 10.0,
                      color: Colors.orange[700],
                      padding: EdgeInsets.all(12.0),
                      onPressed: () {
                        setState(() {
                          isStartMeditationButtonPressed = false;
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text('Done',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ))),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //Notifier to have possibility of loging in/out from the app
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    //HParameterNotifier hParemterNotifier =
    //    Provider.of<HParameterNotifier>(context);

    //Notifier to get data from the slider within "inner widget" function
    //Saves information about the length of the session
    MeditationSessionNotifier meditationSessionNotifier =
        Provider.of<MeditationSessionNotifier>(context);

    //slider to set time of a session
    final sliderSetTime = SleekCircularSlider(
      min: 0,
      max: 180,
      initialValue: 45,
      onChangeStart: (double startValue) {
        startValue = 30;
      },
      appearance: CircularSliderAppearance(
          startAngle: 150,
          angleRange: 357,
          customWidths: CustomSliderWidths(progressBarWidth: 16),
          size: 280,
          infoProperties: InfoProperties(
              mainLabelStyle: TextStyle(color: Colors.white, fontSize: 40),
              //function to format value
              modifier: (double value) {
                //changing to Int
                var roundedValue = value.toInt();
                //one line function to have two digits value
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
        //Function to remove . comma part of the slider's setted value
        //value is being brake down by "." and put into array
        var arr = value.toString().split('.');
        //pick up the vale before "."
        int roundedValue = int.parse(arr[0]);
        //update the Notifier to get the length of the current session
        meditationSessionNotifier.setLengthOfCurrentSession(roundedValue);
        print(value);
      },
    );

    //slider to count down session time
    //at the end of the session show pop up window and sent data to Firebase
    final sliderCountTime = SleekCircularSlider(
        min: 0,
        max: 180,
        initialValue: 0,
        onChangeStart: (double startValue) {
          startValue = 1;
        },
        //Inner widget function to pass value to "external" functions
        innerWidget: (double value) {
          //Function to concatenate values (remove after . part)
          var arr = value.toString().split('.');
          int roundedValue = int.parse(arr[0]);
          print('Concatenaded value: $roundedValue');
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Countdown widget
              Countdown(
                duration: Duration(minutes: roundedValue),
                onFinish: () {
                  //Function to show confirmation dialog and sent data to Firebase
                  _showMyDialog();
                },
                builder: (BuildContext ctx, Duration remaining) {
                  //One line function to present counter data as a XX:XX
                  String twoDigits(int n) => n.toString().padLeft(2, "0");
                  //Present minutes
                  String twoDigitMinutes =
                      twoDigits(remaining.inMinutes.remainder(200));
                  //Present seconds
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
          );
        },
        appearance: CircularSliderAppearance(
            startAngle: 360,
            angleRange: 361,
            customWidths: CustomSliderWidths(
                progressBarWidth: 0, handlerSize: 0, trackWidth: 8),
            size: 280,
            infoProperties: InfoProperties(
                mainLabelStyle: TextStyle(color: Colors.white, fontSize: 40),
                modifier: (double value) {
                  var roundedValue = value.toInt();
                  //One line function to present counter data as a XX min value
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
                Colors.transparent,
                Colors.transparent,
              ],
            )),
        onChange: (double value) {
          print(value);
        });

    print("1 Building Feed");
    print("isVibrationButtonPressed: $isVibrationButtonPressed");

    print(
        "Length of session: ${meditationSessionNotifier.getLengthOfCurrentSession}");

    return Scaffold(
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
                    SizedBox(height: 28),
                    // Text(
                    //   "End session sygnalization",
                    //   style: TextStyle(color: Colors.white, fontSize: 16),
                    // ),
                    // SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(flex: 5),
                        Tooltip(
                          message: "End session sygnalization",
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.orange[50],
                            size: 22,
                          ),
                        ),
                        Spacer(flex: 4),
                        Row(
                          children: [
                            IconButton(
                              tooltip: isVibrationButtonPressed == true
                                  ? 'Vibration ON '
                                  : 'Vibration OFF',
                              icon: isVibrationButtonPressed == true
                                  ? Icon(
                                      Icons.vibration,
                                      color: Colors.white,
                                      size: 36,
                                    )
                                  : Icon(
                                      Icons.vibration,
                                      color: Colors.grey,
                                      size: 36,
                                    ),
                              onPressed: () {
                                setState(() {
                                  isVibrationButtonPressed =
                                      !isVibrationButtonPressed;
                                });
                              },
                            ),
                          ],
                        ),
                        Spacer(flex: 2),
                        //https://stackoverflow.com/questions/56377942/flutter-play-sound-on-button-press
                        IconButton(
                          tooltip: isPlaySoundButtonPressed == true
                              ? 'Sound ON '
                              : 'Sound OFF',
                          icon: isPlaySoundButtonPressed == true
                              ? Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                  size: 36,
                                )
                              : Icon(
                                  Icons.music_note,
                                  color: Colors.grey,
                                  size: 36,
                                ),
                          onPressed: () {
                            setState(() {
                              isPlaySoundButtonPressed =
                                  !isPlaySoundButtonPressed;
                            });
                          },
                        ),

                        Spacer(flex: 12),
                      ],
                    ),
                    SizedBox(height: 50),
                    ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        //width: double.infinity/2,
                        child: RaisedButton(
                          elevation: 10.0,
                          color: Colors.orange,
                          padding: EdgeInsets.all(16.0),
                          onPressed: () {
                            setState(() {
                              isStartMeditationButtonPressed = true;
                            });
                          },
                          child: Text(
                            ' Start session ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
