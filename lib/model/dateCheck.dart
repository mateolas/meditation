//https://stackoverflow.com/questions/57348897/flutter-check-the-date-every-time-an-app-loads

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;

  LifecycleEventHandler({this.resumeCallBack});

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await resumeCallBack();
        break;
    }
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Checking Date App Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Checking Date App'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   String _content = "";

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addObserver(
//         new LifecycleEventHandler(resumeCallBack: () async => _refreshContent()));
//   }

//   void _refreshContent() {
//     setState(() {
//       // Here you can change your widget
//       // each time the app resumed.
//       var now = DateTime.now();

//       // Today
//       if (new DateTime(now.year, now.month, now.day) == new DateTime(2019, 8, 4)) {
//         _content = "Happy Birthday :D";
//       } 
//       // Tomorrow
//       else if (new DateTime(now.year, now.month, now.day) == new DateTime(2019, 8, 5)) {
//         _content = "It passed ONE day for your birthday ;)";
//       } 
//       // After Tomorrow
//       else if (new DateTime(now.year, now.month, now.day) == new DateTime(2019, 8, 6)) {
//         _content = "Did your dreams come true ??";
//       } 
//       // Unknown date
//       else {
//         _content = "Sorry, this day is not allowed. :(";
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               _content,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _refreshContent,
//         tooltip: 'Refresh',
//         child: Icon(Icons.refresh),
//       ),
//     );
//   }
// }