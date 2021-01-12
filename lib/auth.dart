import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hijrah/widgets/provider_widget.dart';

//abstract class BaseAuth {
//  Future<String> signInWithEmailAndPassword(String email, String password);
//  Future<String> createUserWithEmailAndPassword(String email, String password);
//  Future<String> currentUser();
//  Future<void> signOut();
//}

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged =>
      firebaseAuth.onAuthStateChanged.map(
            (FirebaseUser user) => user?.uid,
      );

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = (await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password))
    .user;
    return user.uid;
  }

  Future updateUserName(String name, FirebaseUser currentUser) async {
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
  }

  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = (await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)).user;
    await Firestore.instance.collection("userData").document(user.uid)
        .setData({
      "email": email,
      "admin": false,
      "icFront": false,
      "icBack": false,
        });
    return user.uid;
  }

  Future<String> currentUser() async{
    FirebaseUser user = await firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> signOut() async {
    return await firebaseAuth.signOut();
  }

  // GET UID
  Future<String> getCurrentUID() async {
    return (await firebaseAuth.currentUser()).uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return await firebaseAuth.currentUser();
  }

  //change password
  void _changePasswordFunc(String password) async{
    //Create an instance of the current user.
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_){
      print("Succesfull changed password");
    }).catchError((error){
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

}