import 'package:hive_flutter/hive_flutter.dart';
import 'package:store_user/data/models/product.dart';
import 'package:store_user/data/models/store.dart';
import 'package:store_user/data/models/user.dart' as user_model;
import 'package:store_user/data/services/firebase_firestore_service.dart';

class FavoritesRepository {

  final firestore = FirebaseFirestoreService();
  final user_model.User user = Hive.box('myBox').get('user');
  // fetch user's favorite products
  Future<List<Product>> fetchFavoritesProduct() async {
    
    final List? favoriteProducts = user.favoriteProducts; //reference

    // get products from references
    final List<Product> products = [];
    for (var favoriteProduct in favoriteProducts!) {
      final product = await firestore.getDocument(
        collection: 'products',
        documentId: favoriteProduct.id,
      );
      products.add(Product.fromMap(product.data() as Map<String, dynamic>)
          .copyWith(id: product.id));
    }

    return products;
  }

  Future<List<Store>> fetchFavoritesStore() async {
    final List? favoriteStores = user.favoriteStores;
    final List<Store> stores = [];
    for (var favoriteStore in favoriteStores!){
      final store = await firestore.getDocument(collection: 'stores', documentId: favoriteStore.id);
      stores.add(Store.fromMap(store.data() as Map<String,dynamic>).copyWith(id: store.id));
    }
    return stores;
  }
}
