import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_clone/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:instagram_clone/config/paths.dart';
import 'package:instagram_clone/models/model.dart';

class AuthReporsitory extends BaseAuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;

  AuthReporsitory(
      {FirebaseFirestore firebaseFirestore, auth.FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<auth.User> get user => _firebaseAuth.userChanges();

  @override
  Future<auth.User> signUpWithEmailAndPassword(
      {@required String username,
      @required String email,
      @required String password}) async {
    try {
      auth.UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = credential.user;

      _firebaseFirestore.collection(Paths.users).doc(user.uid).set({
        'username': username,
        'email': email,
        'followers': 0,
        'following': 0
      });

      return user;
    } on auth.FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message);
    } on PlatformException catch (e) {
      throw Failure(code: e.code, message: e.message);
    }
  }

  @override
  Future<auth.User> logInWithEmailAndPassword(
      {@required String email, @required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (credential == null) throw 'Unable to login user: $email';

      return credential.user;
    } on auth.FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message);
    } on PlatformException catch (e) {
      throw Failure(code: e.code, message: e.message);
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}
