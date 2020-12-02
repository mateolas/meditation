import 'package:flutter/material.dart';

class AddParameter extends StatelessWidget {
  AddParameter();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Padding(
        padding: const EdgeInsets.all(32.0),
        child: new Text(
          'This is the modal bottom sheet. Click anywhere to dismiss.',
          textAlign: TextAlign.center,
          style: new TextStyle(
              color: Theme.of(context).accentColor, fontSize: 24.0),
        ),
      ),
    );
  }
}
