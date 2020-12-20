import 'package:health_parameters_tracker/model/hParameter.dart';
import 'package:health_parameters_tracker/model/user.dart';
import 'package:health_parameters_tracker/notifier/auth_notifier.dart';
import 'package:health_parameters_tracker/notifier/bill_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

//
//######### AUTHORIZATION #########
//



 final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle(AuthNotifier authNotifier) async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

     if (user != null) {
  authNotifier.setUser(user);
  print("'signInWithGoogle succeeded: $user'");
     }

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle(AuthNotifier authNotifier) async {
  await googleSignIn.signOut();

    await FirebaseAuth.instance
      .signOut()
      .catchError((error) => print(error.code));

  authNotifier.setUser(null);

  print("User Sign Out");
}

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
  print("FirebaseUser $firebaseUser");

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
