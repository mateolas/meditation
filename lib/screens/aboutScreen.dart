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
      body: Column(
        children: [
          SizedBox(height: 24),
          Image.asset('lib/assets/images/hpt_sign_logo_circle_green.png',
              scale: 1.3),
          SizedBox(height: 6),
          Container(
            alignment: Alignment.center,
            child: Text('Health parameters tracker',
                style: TextStyle(color: accentCustomColor, fontSize: 22)),
          ),
          SizedBox(height: 32),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              alignment: Alignment.topLeft,
              child: Text('Hi !', style: TextStyle(fontSize: 18))),
        ],
      ),
    );
  }
}
