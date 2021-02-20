import 'package:flutter/material.dart';
import 'package:take_a_breath/model/colors.dart';

class MeditationStatistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //card to hold chart + buttons

            Container(
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
           
              height: MediaQuery.of(context).size.height/8,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }
}
