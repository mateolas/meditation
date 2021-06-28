import 'package:flutter/material.dart';

//<div>Icons made by <a href="https://www.flaticon.com/authors/good-ware" title="Good Ware">Good Ware</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>

class AboutScreen extends StatelessWidget {
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
              Color(0xffFFE000),
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
                            'Thank you for checking up the Take a Breath app. Thanks to it you\'re able to monitor and record the basic health parameters. ',
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
                            style:
                                TextStyle(fontSize: 18, color: Colors.black))),
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                        alignment: Alignment.topLeft,
                        child: Text('- Pulse (with measurement functionality) ',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black))),
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                        alignment: Alignment.topLeft,
                        child: Text('- Saturation ',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black))),
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                        alignment: Alignment.topLeft,
                        child: Text('- Weight ',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black))),
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                        alignment: Alignment.topLeft,
                        child: Text(
                            'Please remember that pulse measurement functionality embedded into app can be used only for reference and can\'t replace professional clinical tests.',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black))),
                    SizedBox(height: 18),
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                        alignment: Alignment.topLeft,
                        child: Text('Stay safe ! ',
                            style: TextStyle(fontSize: 18))),
                    SizedBox(height: 12),
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 4, 8),
                        alignment: Alignment.topLeft,
                        child: Text('Take a breath team',
                            style: TextStyle(fontSize: 18))),
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 4, 0),
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
    );
  }
}
