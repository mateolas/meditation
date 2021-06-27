import 'package:flutter/material.dart';
import 'package:take_a_breath/screens/settingsSoundsScreen.dart';

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
                Color(0xffe65c00),
                Color(0xffFFE000),
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
