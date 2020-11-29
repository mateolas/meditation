import 'dart:io';
import 'package:archive_your_bill/model/globals.dart';
import 'package:archive_your_bill/model/bill.dart';
import 'package:archive_your_bill/model/user.dart';
import 'package:archive_your_bill/notifier/auth_notifier.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

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

//function to get list of bills from the firebase
getBills(BillNotifier billNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  //DocumentReference documentRef = await Firestore.instance.collection('userData').document(firebaseUser.uid).collection('bills').add(food.toMap());

  QuerySnapshot snapshot = await Firestore.instance
      .collection('userData')
      .document(firebaseUser.uid)
      .collection('bills')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Bill> _billList = [];

  snapshot.documents.forEach((document) {
    Bill bill = Bill.fromMap(document.data);
    _billList.add(bill);
  });

  billNotifier.billList = _billList;

}

//function to get list of bills from the firebase
getBillsBasedOnCategory(BillNotifier billNotifier, int index) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  List namesOfCategories = ['All', 'Electronics', 'Fashion','Sports','Books/Music/Culture','Home','Food','Health','Services','Other'];
  
  if (index == 0) {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('userData')
        .document(firebaseUser.uid)
        .collection('bills')
        .orderBy("createdAt", descending: true)
        .getDocuments();

    List<Bill> _billList = [];

    snapshot.documents.forEach((document) {
      Bill bill = Bill.fromMap(document.data);
      _billList.add(bill);
    });

    billNotifier.billList = _billList;
    
    if(billNotifier.billList.isEmpty){
      isAllSelected = true;
    }

  } 
  else {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('userData')
        .document(firebaseUser.uid)
        .collection('bills')
        .where("category", isEqualTo: namesOfCategories[index])
        .getDocuments();

    List<Bill> _billList = [];
    snapshot.documents.forEach((document) {
      Bill bill = Bill.fromMap(document.data);
      _billList.add(bill);
    });

    billNotifier.billList = _billList;
       isAllSelected = false;
  }

}

uploadBillAndImage(
    Bill bill, bool isUpdating, File localFile, Function foodUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('archive/images/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadBill(bill, isUpdating, foodUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadBill(bill, isUpdating, foodUploaded);
  }
}

_uploadBill(Bill bill, bool isUpdating, Function billUploaded,
    {String imageUrl}) async {
  CollectionReference foodRef = Firestore.instance.collection('userData');

  if (imageUrl != null) {
    bill.image = imageUrl;
  }

  if (isUpdating) {
    bill.updatedAt = Timestamp.now();
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    await foodRef
        .document(firebaseUser.uid)
        .collection('bills')
        .document(bill.id)
        .updateData(bill.toMap());

    billUploaded(bill);

    print('updated food with id: ${bill.id}');
  } else {
    bill.createdAt = Timestamp.now();

    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    DocumentReference documentRef = await foodRef
        .document(firebaseUser.uid)
        .collection('bills')
        .add(bill.toMap());

    bill.id = documentRef.documentID;

    print('uploaded food successfully: ${bill.toString()}');

    await documentRef.setData(bill.toMap(), merge: true);

    billUploaded(bill);
  }
}

deleteBill(Bill bill, Function foodDeleted) async {
  if (bill.image != null) {
    StorageReference storageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(bill.image);

    print(storageReference.path);

    await storageReference.delete();

    print('image deleted');
  }
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
  await Firestore.instance
      .collection('userData')
      .document(firebaseUser.uid)
      .collection('bills')
      .document(bill.id)
    ..delete();

  foodDeleted(bill);
 
}
