import 'package:flutter/material.dart';
import 'package:health_parameters_tracker/model/colors.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          'Welcome',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 3,
              margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                children: [
                  Image.asset(
                      'lib/assets/images/hpt_sign_logo_circle_green.png',
                      scale: 1.3),
                  SizedBox(height: 6),
                  Container(
                    alignment: Alignment.center,
                    child: Text('Health parameters tracker',
                        style:
                            TextStyle(color: accentCustomColor, fontSize: 22)),
                  ),
                  SizedBox(height: 32),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                      alignment: Alignment.topLeft,
                      child: Text('Hi !',
                          softWrap: true, style: TextStyle(fontSize: 18))),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                      alignment: Alignment.topLeft,
                      child: Text(
                          'Thank you for checking up the Health Parameters Tracker app. Thanks to it you\'re able to monitor and record the basic health parameters. ',
                          style: TextStyle(fontSize: 18))),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                      alignment: Alignment.topLeft,
                      child: Text(
                          'All the data is securely kept at Google servers and you can access them from any Android device.',
                          style: TextStyle(fontSize: 18))),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                      alignment: Alignment.topLeft,
                      child: Text(
                          'Currently app supports recording below parameters: ',
                          style: TextStyle(fontSize: 18))),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                      alignment: Alignment.topLeft,
                      child: Text('- Temperature ',
                          style: TextStyle(fontSize: 18, color: Colors.black))),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                      alignment: Alignment.topLeft,
                      child: Text('- Pulse (with measurement functionality) ',
                          style: TextStyle(fontSize: 18, color: Colors.black))),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                      alignment: Alignment.topLeft,
                      child: Text('- Saturation ',
                          style: TextStyle(fontSize: 18, color: Colors.black))),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                      alignment: Alignment.topLeft,
                      child: Text('- Weight ',
                          style: TextStyle(fontSize: 18, color: Colors.black))),
                  SizedBox(height: 12),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                      alignment: Alignment.topLeft,
                      child:
                          Text('Stay safe ! ', style: TextStyle(fontSize: 18))),
                  SizedBox(height: 12),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                      alignment: Alignment.topLeft,
                      child: Text('Health parameters tracker team',
                          style: TextStyle(fontSize: 18))),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                      alignment: Alignment.topLeft,
                      child: Text('', style: TextStyle(fontSize: 18))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
