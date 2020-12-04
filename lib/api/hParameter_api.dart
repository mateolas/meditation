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


//function to get list of bills from the firebase
// getHParameters(HParameterNotifier billNotifier,
//     String temperatureDayWeekTypeOfView) async {
//   var now = new DateTime.now();
//   var now_1d = now.subtract(Duration(days: 1));
//   var now_1w = now.subtract(Duration(days: 7));
//   var now_1m = new DateTime(now.year, now.month - 1, now.day);
//   var now_1y = new DateTime(now.year - 1, now.month, now.day);
//   var timePeriod;
//   FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

//   //DocumentReference documentRef = await Firestore.instance.collection('userData').document(firebaseUser.uid).collection('bills').add(food.toMap());

//   switch (temperatureDayWeekTypeOfView) {
//     case 'Day':
//       {
//         timePeriod = now_1d;
//       }
//       break;

//     case 'Week':
//       {
//         timePeriod = now_1w;
//       }
//       break;

//     case 'Month':
//       {
//         timePeriod = now_1m;
//       }
//       break;

//     case 'Year':
//       {
//         timePeriod = now_1y;
//       }
//       break;

//     default:
//       {
//         timePeriod = now_1d;
//       }
//       break;
//   }

//   QuerySnapshot snapshot = await Firestore.instance
//       .collection('userData')
//       .document(firebaseUser.uid)
//       .collection('hParameters')
//       .orderBy("createdAt", descending: true)
//       .where("createdAt", isGreaterThanOrEqualTo: timePeriod)
//       .getDocuments();

//   List<Hparameter> _hParametersList = [];

//   snapshot.documents.forEach((document) {
//     Hparameter bill = Hparameter.fromMap(document.data);
//     _hParametersList.add(bill);
//   });

//   billNotifier.hParameterList = _hParametersList;
// }

//function to get list of bills from the firebase
getBillsBasedOnCategory(HParameterNotifier billNotifier, int index) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  List namesOfCategories = [
    'All',
    'Electronics',
    'Fashion',
    'Sports',
    'Books/Music/Culture',
    'Home',
    'Food',
    'Health',
    'Services',
    'Other'
  ];

  if (index == 0) {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('userData')
        .document(firebaseUser.uid)
        .collection('bills')
        .orderBy("createdAt", descending: true)
        .getDocuments();

    List<Hparameter> _billList = [];

    snapshot.documents.forEach((document) {
      Hparameter bill = Hparameter.fromMap(document.data);
      _billList.add(bill);
    });

    billNotifier.hParameterList = _billList;

    if (billNotifier.hParameterList.isEmpty) {
      isAllSelected = true;
    }
  } else {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('userData')
        .document(firebaseUser.uid)
        .collection('bills')
        .where("category", isEqualTo: namesOfCategories[index])
        .getDocuments();

    List<Hparameter> _billList = [];

    snapshot.documents.forEach((document) {
      Hparameter bill = Hparameter.fromMap(document.data);
      _billList.add(bill);
    });

    billNotifier.hParameterList = _billList;
    isAllSelected = false;
  }
}

// uploadBillAndImage(
//     Hparameter bill, bool isUpdating, File localFile, Function foodUploaded) async {
//   if (localFile != null) {
//     print("uploading image");

//     var fileExtension = path.extension(localFile.path);
//     print(fileExtension);

//     var uuid = Uuid().v4();

//     final StorageReference firebaseStorageRef = FirebaseStorage.instance
//         .ref()
//         .child('archive/images/$uuid$fileExtension');

//     await firebaseStorageRef
//         .putFile(localFile)
//         .onComplete
//         .catchError((onError) {
//       print(onError);
//       return false;
//     });

//     String url = await firebaseStorageRef.getDownloadURL();
//     print("download url: $url");
//     _uploadBill(bill, isUpdating, foodUploaded, imageUrl: url);
//   } else {
//     print('...skipping image upload');
//     _uploadBill(bill, isUpdating, foodUploaded);
//   }
// }

uploadBill(Hparameter hParameter, Function billUploaded) async {
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

  billUploaded(hParameter);
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
