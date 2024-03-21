import 'package:store_user/data/models/category.dart';
import 'package:store_user/data/services/firebase_firestore_service.dart';

class ExploreRepository {
  final FirebaseFirestoreService _firebaseFirestoreService =
      FirebaseFirestoreService();

  Future<List<Category>> getCategories() async {
    final snapshot =
        await _firebaseFirestoreService.getCollection('categories');

    return snapshot.docs
        .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>)
            .copyWith(id: doc.id))
        .toList();
  }
}
