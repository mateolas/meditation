import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

//class which enables to use provider

class AuthNotifier with ChangeNotifier {
  FirebaseUser _user;

  FirebaseUser get user => _user;

  //informing different part of the app that user has changed
  void setUser(FirebaseUser user) {
    _user = user;
    notifyListeners();
  }
}
