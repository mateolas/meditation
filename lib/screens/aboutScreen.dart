import 'package:flutter/material.dart';

//<div>Icons made by <a href="https://www.flaticon.com/authors/good-ware" title="Good Ware">Good Ware</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffe65c00),
                Colors.white,
                Colors.white,
                Colors.white,
                Colors.white,
                Color(0xffe65c00),
                //Colors.white
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
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Image.asset('lib/assets/images/lotus.png',
                            scale: 5.0),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        child: Text('Take a breath',
                            style: TextStyle(
                                color: Color(0xffe65c00), fontSize: 22)),
                      ),
                      SizedBox(height: 48),
                      Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                          alignment: Alignment.topLeft,
                          child: Text('Hi !',
                              softWrap: true, style: TextStyle(fontSize: 18))),
                      Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                          alignment: Alignment.topLeft,
                          child: Text(
                              'Thank you for checking up the Take a Breath app. Thanks to it you\'re able to control length of your meditation sessions. Set a timer, press start and Take a breath (by sound and/or vibration) will inform you that time has elapsed.',
                              style: TextStyle(fontSize: 18))),
                      Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                          alignment: Alignment.topLeft,
                          child: Text(
                              'All sessions are recorded and archived that you could monitor your meditation progress through the time.',
                              style: TextStyle(fontSize: 18))),
                      Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                          alignment: Alignment.topLeft,
                          child: Text(
                              'In the Videos section we added few YouTube channels related to mindfulness topic to help you stayed inspired.',
                              style: TextStyle(fontSize: 18))),
                      SizedBox(height: 18),
                      Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                          alignment: Alignment.topLeft,
                          child: Text('Wish you a wonderful journey !',
                              style: TextStyle(fontSize: 18))),
                      SizedBox(height: 18),
                      Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                          alignment: Alignment.topLeft,
                          child: Text('Take a breath team',
                              style: TextStyle(fontSize: 18))),
                      Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 4, 10),
                          alignment: Alignment.topLeft,
                          child: Text('', style: TextStyle(fontSize: 18))),
                    ],
                  ),
                ),
                SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
