import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:wakelock/wakelock.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/src/painting/text_style.dart' as textStyle;

import 'package:health_parameters_tracker/widgets/pulseChart.dart';

import 'package:health_parameters_tracker/model/colors.dart';

import 'package:flutter/rendering.dart';

class PulseMeasurementMainPage extends StatefulWidget {
  @override
  HomePageView createState() {
    return HomePageView();
  }
}

class HomePageView extends State<PulseMeasurementMainPage>
    with SingleTickerProviderStateMixin {
  bool _toggled = false; // toggle button value
  List<SensorValue> _data = List<SensorValue>(); // array to store the values
  CameraController _controller;
  double _alpha = 0.3; // factor for the mean value
  AnimationController _animationController;
  double _iconScale = 1;
  int _bpm = 0; // beats per minute
  int _fs = 30; // sampling frequency (fps)
  int _windowLen = 30 * 6; // window length to display - 6 seconds
  CameraImage _image; // store the last camera image
  double _avg; // store the average value during calculation
  DateTime _now; // store the now Datetime
  Timer _timer; // timer for image processing

  bool hasflashlight = false; //to set is there any flashlight ?
  bool isturnon = false; //to set if flash light is on or off
  IconData flashicon = Icons.flash_off; //icon for lashlight button

  @override
  void initState() {
    super.initState();
    //initialization of animation controller
    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animationController
      ..addListener(() {
        setState(() {
          _iconScale = 1.0 + _animationController.value * 0.4;
        });
      });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _toggled = false;
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true, // hides default back button
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentCustomColor,
                primaryCustomColor,
              ],
            ),
          ),
        ),
        title: Text(
          'Pulse measurement (beta)',
          style: textStyle.TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: <Widget>[
                            _controller != null && _toggled
                                ? AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: CameraPreview(_controller),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(12),
                                    alignment: Alignment.center,
                                    color: Colors.grey[300],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                _toggled
                    ? "Cover both the camera and the flash with your finger"
                    : "Camera feed will display here",
                style: textStyle.TextStyle(
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 40),
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    _toggled
                        ? "Press heart icon to STOP"
                        : "Press heart icon to START",
                    style: textStyle.TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                Center(
                  child: Transform.scale(
                    scale: _iconScale,
                    child: IconButton(
                      icon: Icon(
                          _toggled ? Icons.favorite : Icons.favorite_border),
                      color: Colors.red,
                      iconSize: 90,
                      onPressed: () {
                        if (_toggled) {
                          _untoggle();
                        } else {
                          _toggle();
                        }
                      },
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 12,),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          _toggled
                              ? "Cover camera with finger and wait few seconds for stabilization of a graph"
                              : " ",
                          style: textStyle.TextStyle(
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                      // Text(
                      //   "Estimated BPM",
                      //   style: textStyle.TextStyle(
                      //       fontSize: 18, color: Colors.red),
                      // ),
                      // Text(
                      //   (_bpm > 30 && _bpm < 150 ? _bpm.toString() : "--"),
                      //   style: textStyle.TextStyle(
                      //       color: Colors.red,
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.bold),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    color: Colors.white),
                child: Chart(_data),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearData() {
    // create array of 128 ~= 255/2
    _data.clear();
    int now = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < _windowLen; i++)
      _data.insert(
          0,
          SensorValue(
              DateTime.fromMillisecondsSinceEpoch(now - i * 1000 ~/ _fs), 128));
  }

  void _toggle() {
    _clearData();
    _initController().then((onValue) {
      Wakelock.enable();
      _animationController?.repeat(reverse: true);
      setState(() {
        _toggled = true;
      });
      // after is toggled
      _initTimer();
      _updateBPM();
    });
  }

  void _untoggle() {
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.value = 0.0;
    setState(() {
      _toggled = false;
    });
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  Future<void> _initController() async {
    try {
      List _cameras = await availableCameras();
      _controller = CameraController(_cameras.first, ResolutionPreset.low);
      await _controller.initialize();
      //turn on the camera's flashlight here
      final cameras = await availableCameras();
      cameras.first;

      Future.delayed(Duration(milliseconds: 100)).then((onValue) {
        _controller.flash(true);
      });
      _controller.startImageStream((CameraImage image) {
        _image = image;
      });
    } catch (Exception) {
      debugPrint(Exception);
    }
  }

  void _initTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 500 ~/ _fs), (timer) {
      if (_toggled) {
        if (_image != null) _scanImage(_image);
      } else {
        timer.cancel();
      }
    });
  }

  void _scanImage(CameraImage image) {
    _now = DateTime.now();
    _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;
    if (_data.length >= _windowLen) {
      _data.removeAt(0);
    }
    setState(() {
      _data.add(SensorValue(_now, _avg));
    });
  }

  void _updateBPM() async {
    // Bear in mind that the method used to calculate the BPM is very rudimentar
    // feel free to improve it :)

    // Since this function doesn't need to be so "exact" regarding the time it executes,
    // I only used the a Future.delay to repeat it from time to time.
    // Ofc you can also use a Timer object to time the callback of this function
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;
    double _bpm;
    int _counter;
    int _previous;
    while (_toggled) {
      _values = List.from(_data); // create a copy of the current data array
      _avg = 0;
      _n = _values.length;
      _m = 0;
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
      _threshold = (_m + _avg) / 2;
      _bpm = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpm += 60 *
                1000 /
                (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      if (_counter > 0) {
        _bpm = _bpm / _counter;
        print(_bpm);
        setState(() {
          this._bpm = ((1 - _alpha) * this._bpm + _alpha * _bpm).toInt();
        });
      }
      await Future.delayed(Duration(
          milliseconds:
              1000 * _windowLen ~/ _fs)); // wait for a new set of _data values
    }
  }
}
