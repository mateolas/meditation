import 'package:flutter/material.dart';
import 'package:health_parameters_tracker/model/colors.dart';

class MeditationStatistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
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
        title: Text(
          'Welcome',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xffa8e063),
              Colors.white
              //Color(0xff56ab2f),
              //Color(0xffa8e063),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 6,
                margin: EdgeInsets.fromLTRB(6, 12, 6, 12),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 28, 0, 0),
                      child: Image.asset(
                          'lib/assets/images/hpt_sign_logo_circle_green.png',
                          scale: 1.3),
                    ),
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      child: Text('Health parameters tracker',
                          style: TextStyle(
                              color: accentCustomColor, fontSize: 22)),
                    ),
                    SizedBox(height: 48),
                  ],
                ),
              ),
              SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
