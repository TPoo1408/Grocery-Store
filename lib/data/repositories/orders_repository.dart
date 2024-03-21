import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:store_user/data/models/user.dart' as user_model;
import 'package:store_user/data/models/order.dart' as order_model;
import 'package:store_user/data/services/firebase_firestore_service.dart';

class OrderRepository{
  final orderCollection = FirebaseFirestore.instance.collection('order');
  final user_model.User user = Hive.box('myBox').get('user');

  Future<void> createOrder(order_model.Order myOrder) async {
    try{
      await orderCollection.doc(user.uid).set({
        'orders': FieldValue.arrayUnion([myOrder.toMap()])
      }, SetOptions(merge: true));
    } catch(e){
      rethrow;
    }
  }

  Future<List<order_model.Order>> fetchOrders() async{
    try{
      List<order_model.Order> myOrderDetail = [];
      await orderCollection.doc(user.uid).get().then((value) {
        if (value.exists){
          myOrderDetail = (value.data()!['orders'] as List<dynamic>).map(
            (e) => order_model.Order.fromMap(e as Map<String,dynamic>)).toList();
        }
      }
      );
      return myOrderDetail;
    }
    catch(e){
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try{
      await FirebaseFirestoreService().deleteDocument(collection: 'cart', documentId: user.uid);
    } catch (e){
      rethrow;
    }
  }
    
}