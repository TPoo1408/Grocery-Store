import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:store_user/data/models/order_product.dart';
import 'package:store_user/data/models/product.dart';
import 'package:store_user/data/models/user.dart' as user_model;
import 'package:store_user/data/services/firebase_firestore_service.dart';

class ProductRepository {
  final _firestore = FirebaseFirestoreService();
  static final List<OrderProduct> cart = [];
  static var box = Hive.box('myBox');

  static bool isFavorite(Product product) {
    // get user
    user_model.User user = box.get("user");

    // initialize favoriteProducts if null
    user.favoriteProducts ??= [];

    // check if product is in favorite
    return user.favoriteProducts?.contains(
          FirebaseFirestore.instance.collection('products').doc(product.id),
        ) ??
        false;
  }

  // update favorite
  Future<void> updateFavorite(Product product, bool isFavorite) async {
    // document reference
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('products').doc(product.id);

    // get user
    user_model.User user = box.get("user");

    // initialize favoriteProducts if null
    user.favoriteProducts ??= [];

    // add or remove from favorite
    if (isFavorite) {
      user.favoriteProducts?.add(documentReference);
    } else {
      user.favoriteProducts?.remove(documentReference);
    }

    // update in hive
    await box.put('user', user);

    // update in firestore
    await _firestore.updateDocumentWithQuery(
      collection: "users",
      field: "uid",
      value: user.uid,
      data: {
        "favoriteProducts": user.favoriteProducts,
      },
    );
  }
}
