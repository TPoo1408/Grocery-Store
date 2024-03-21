import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:store_user/data/models/address.dart';
import 'package:store_user/data/models/user.dart' as user_model;
import 'package:store_user/data/services/auth_service.dart';
import 'package:store_user/data/services/firebase_firestore_service.dart';

class LoginRepository {
  final AuthService _authService = AuthService();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await _authService.signInWithEmailAndPassword(
      email,
      password,
    );

    // get user data from firestore
    final snapshot = await FirebaseFirestoreService().getDocumentsWithQuery(
      'users',
      'uid',
      userCredential.user!.uid,
    );

    // convert to model
    final user = user_model.User.fromMap(
        snapshot.docs.first.data() as Map<String, dynamic>);

    // save to hive
    await Hive.box('myBox').put('user', user);
  }

}
