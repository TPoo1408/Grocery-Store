import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:store_user/data/models/user.dart' as user_model;

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Get Current User
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();



  // Email and Password Sign In
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(getErrorString(e.code));
    }
  }

  // Email and Password Sign Up
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(getErrorString(e.code));
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(getErrorString(e.code));
    }
  }

  // Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(getErrorString(e.code));
    }
  }

  // Save User Data
  void saveUser(user_model.User user) {
    try {
      // save user data to hive
      Hive.box('myBox').put('user', user);
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
    }
  }

  // Error Handling
  String getErrorString(String errorCode) {
    switch (errorCode) {
      case "invalid-email":
        return "Invalid email or password.";
      case "wrong-password":
        return "Invalid email or password.";
      case "user-not-found":
        return "User with this email doesn't exist.";
      case "user-disabled":
        return "User with this email has been disabled.";
      case "too-many-requests":
        return "Too many requests. Try again later.";
      case "operation-not-allowed":
        return "Signing in with Email and Password is not enabled.";
      case "email-already-in-use":
        return "An account already exists for this email.";
      case "weak-password":
        return "Password should be at least 6 characters.";
      default:
        return errorCode;
    }
  }
}
