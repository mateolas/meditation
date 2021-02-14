import 'package:flutter/material.dart';
import 'package:take_a_breath/screens/aboutScreen.dart';
import 'package:take_a_breath/screens/feedbackScreen.dart';
import 'package:take_a_breath/screens/settingsScreen.dart';
import 'package:take_a_breath/notifier/auth_notifier.dart';
import 'package:take_a_breath/api/meditationSession_api.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
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
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text('Health',
                        style: TextStyle(fontSize: 26, color: Colors.white)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text('Parameters',
                        style: TextStyle(fontSize: 26, color: Colors.white)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text('Tracker',
                        style: TextStyle(fontSize: 26, color: Colors.white)),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.verified_user),
          //   title: Text('Profile'),
          //   onTap: () => {Navigator.of(context).pop()},
          // ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.border_color),
          //   title: Text('Feedback'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => FeedbackScreen()),
          //     );
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => signOutGoogle(authNotifier),
          ),
        ],
      ),
    );
  }
}
