import 'package:flutter/material.dart';
import 'package:take_a_breath/notifier/meditationSession_notifier.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

//enum values to "name" the different radio buttons (just like "one", "two" etc. )
enum SoundTypes { mediumBell, largeBell, veryLargeBell }

/// This is the stateful widget that the main application instantiates.
class UnitsScreen extends StatefulWidget {
  UnitsScreen({Key key}) : super(key: key);

  @override
  _UnitsScreenState createState() => _UnitsScreenState();

  /// This is the private State class that goes with MyStatefulWidget.
}

class _UnitsScreenState extends State<UnitsScreen> {
  var _pickedSoundTypeRadioValue;
  //variables to play sound
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();

  //function to play sound on the end of the session
  Future<void> _playSound(String soundName) async {
    var bytes = await (await audioCache.load(soundName)).readAsBytes();
    audioCache.playBytes(bytes);
  }

  @override
  void initState() {
    //init state with unitsNotifier
    MeditationSessionNotifier soundTypeNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);

    //
    //Sound Types
    //
    //check if unitsNotifier is null
    //if unitsNotifier is null, set default value to celsius values
    if (soundTypeNotifier.getSoundName == null) {
      _pickedSoundTypeRadioValue = SoundTypes.mediumBell;
    }
    //if unitsNotifier is not empty, check what type of sound was chosen

    print('Get sound name from notifier from init ${soundTypeNotifier.getSoundName}');
    if (soundTypeNotifier.getSoundName == "medium_bell.mp3") {
      _pickedSoundTypeRadioValue = SoundTypes.mediumBell;
    }
    if (soundTypeNotifier.getSoundName == "large_bell.mp3") {
      _pickedSoundTypeRadioValue = SoundTypes.largeBell;
    }
    if (soundTypeNotifier.getSoundName == "very_large_bell.mp3") {
      _pickedSoundTypeRadioValue = SoundTypes.veryLargeBell;
    }

    //for debug puproses

    super.initState();
  }

  Widget build(BuildContext context) {
    MeditationSessionNotifier soundTypeNotifier =
        Provider.of<MeditationSessionNotifier>(context, listen: false);

      print('Get sound name from notifier from buil ${soundTypeNotifier.getSoundName}');
    // print('BUILD Pounds boolean: ${unitsNotifier.getIsPound}');
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
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
          'Sounds',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(24, 12, 0, 0),
            child: Text(
              'End session sounds to play',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text('Medium bell', style: TextStyle(fontSize: 16)),
            leading: Radio(
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //value - "label" of a particular radio button
              value: SoundTypes.mediumBell,
              //groupValue - output value of a particular group of radio buttons
              groupValue: _pickedSoundTypeRadioValue,
              onChanged: (value) {
                setState(() {
                  //to mark proper radio button
                  _pickedSoundTypeRadioValue = value;
                  MeditationSessionNotifier soundTypeNotifier =
                      Provider.of<MeditationSessionNotifier>(context,
                          listen: false);
                  //updating the Notifier state
                  soundTypeNotifier.setSoundName('medium_bell.mp3');
                  _playSound('medium_bell.mp3');
                  //print('Celsius boolean: ${unitsNotifier.getIsCelsius}');
                  //print('Fahrenheit boolean: ${unitsNotifier.getIsFahrenheit}');
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Large bell', style: TextStyle(fontSize: 16)),
            leading: Radio(
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //value - "label" of a particular radio button
              value: SoundTypes.largeBell,
              //groupValue - output value of a particular group of radio buttons
              groupValue: _pickedSoundTypeRadioValue,
              onChanged: (value) {
                setState(() {
                  //to mark proper radio button
                  _pickedSoundTypeRadioValue = value;
                  MeditationSessionNotifier soundTypeNotifier =
                      Provider.of<MeditationSessionNotifier>(context,
                          listen: false);
                  //updating the Notifier state
                  soundTypeNotifier.setSoundName('large_bell.mp3');
                  _playSound('large_bell.mp3');
                  //print('Celsius boolean: ${unitsNotifier.getIsCelsius}');
                  //print('Fahrenheit boolean: ${unitsNotifier.getIsFahrenheit}');
                });
              },
            ),
          ),
          ListTile(
            title:
                const Text('Very large bell', style: TextStyle(fontSize: 16)),
            leading: Radio(
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //value - "label" of a particular radio button
              value: SoundTypes.veryLargeBell,
              //groupValue - output value of a particular group of radio buttons
              groupValue: _pickedSoundTypeRadioValue,
              onChanged: (value) {
                setState(() {
                  //to mark proper radio button
                  _pickedSoundTypeRadioValue = value;
                  MeditationSessionNotifier soundTypeNotifier =
                      Provider.of<MeditationSessionNotifier>(context,
                          listen: false);
                  //updating the Notifier state
                  soundTypeNotifier.setSoundName('very_large_bell.mp3');
                  _playSound('very_large_bell.mp3');
                  //print('Celsius boolean: ${unitsNotifier.getIsCelsius}');
                  //print('Fahrenheit boolean: ${unitsNotifier.getIsFahrenheit}');
                });
              },
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
