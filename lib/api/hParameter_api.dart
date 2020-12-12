import 'dart:io';
import 'package:archive_your_bill/model/globals.dart';
import 'package:archive_your_bill/model/hParameter.dart';
import 'package:archive_your_bill/model/user.dart';
import 'package:archive_your_bill/notifier/auth_notifier.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

//
//######### AUTHORIZATION #########
//

login(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
    }
  }
}

signup(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = user.displayName;

    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      await firebaseUser.updateProfile(updateInfo);

      await firebaseUser.reload();

      print("Sign up: $firebaseUser");

      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      authNotifier.setUser(currentUser);
    }
  }
}

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance
      .signOut()
      .catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}

// GET UID
Future<String> getCurrentUID() async {
  return (await FirebaseAuth.instance.currentUser()).uid;
}

//
//#################################
//


getHParameters(HParameterNotifier hParameterNotifier) async {
 
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  //DocumentReference documentRef = await Firestore.instance.collection('userData').document(firebaseUser.uid).collection('bills').add(food.toMap());

  

  QuerySnapshot snapshot = await Firestore.instance
      .collection('userData')
      .document(firebaseUser.uid)
      .collection('hParameters')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Hparameter> _hParametersList = [];

  snapshot.documents.forEach((document) {
    Hparameter bill = Hparameter.fromMap(document.data);
    _hParametersList.add(bill);
  });

  hParameterNotifier.hParameterList = _hParametersList;
}


uploadBill(Hparameter hParameter, Function hParameterUploaded) async {
  CollectionReference hParameterRef = Firestore.instance.collection('userData');

  hParameter.createdAt = Timestamp.now();

  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  DocumentReference documentRef = await hParameterRef
      .document(firebaseUser.uid)
      .collection('hParameters')
      .add(hParameter.toMap());

  hParameter.id = documentRef.documentID;

  print('uploaded hParameters successfully: ${hParameter.toString()}');

  await documentRef.setData(hParameter.toMap(), merge: true);

  hParameterUploaded(hParameter);
}

deleteBill(Hparameter bill, Function foodDeleted) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
  await Firestore.instance
      .collection('userData')
      .document(firebaseUser.uid)
      .collection('bills')
      .document(bill.id)
    ..delete();

  foodDeleted(bill);
}
