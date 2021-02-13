import 'package:flutter/material.dart';
import 'package:health_parameters_tracker/screens/settingsSoundsScreen.dart';

class SettingsScreen extends StatelessWidget {
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
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: ListTile(
              title: new Text('End session notification sounds'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UnitsScreen()),
                );
              },
            ),
            decoration: new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide(color: Colors.grey[300]))),
          ),
        ],
      ),
    );
  }
}
