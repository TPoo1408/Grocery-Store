import 'package:store_user/data/models/product.dart';
import 'package:store_user/data/services/firebase_firestore_service.dart';

class SearchRepository {
  final _firestoreService = FirebaseFirestoreService();

  Future<List<Product>> searchProducts(String query) async {
    final snapshot = await _firestoreService.getDocumentsWithQuery(
      "products",
      "name",
      query,
    );

    print(snapshot.docs.length);

    return snapshot.docs
        .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
