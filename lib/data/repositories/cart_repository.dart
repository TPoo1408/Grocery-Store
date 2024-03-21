import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:store_user/data/models/cart.dart';
import 'package:store_user/data/models/order.dart';
import 'package:store_user/data/models/order_product.dart';
import 'package:store_user/data/models/user.dart' as user_model;
import 'package:store_user/data/services/firebase_firestore_service.dart';

class CartRepository{

  final firestore = FirebaseFirestoreService();
  final user_model.User user = Hive.box('myBox').get('user');

  Future<Cart> fetchCart() async{
    final myCartRef = await firestore.getDocument(collection: 'cart', documentId: user.uid);

    Cart myCart = Cart(id: user.uid, cartProducts: const []);
    if (myCartRef.exists){
      myCart = Cart.fromMap(myCartRef.data() as Map<String, dynamic>);
    } 
   
    return myCart;
  }

  Future<void> updateCart(OrderProduct orderProduct, num quantity) async{
    if (quantity < 0) return;
    final myCartRef = await  firestore.getDocument(collection: 'cart', documentId: user.uid);
    
    if  (myCartRef.exists){
       final Cart myCart = Cart.fromMap(myCartRef.data() as Map<String, dynamic>);
       List<OrderProduct> cartProductsData = myCart.cartProducts ?? [];
       final currentProductIndex = cartProductsData.indexWhere((element) => element.product == orderProduct.product);
      if (currentProductIndex > -1){
        cartProductsData[currentProductIndex].quantity = quantity;

        if (quantity == 0){
          cartProductsData.removeAt(currentProductIndex);
        }
      } else {

        orderProduct.quantity = quantity;
        cartProductsData.add(orderProduct);
      }
      await firestore.updateDocument('cart',user.uid, myCart.toMap());
    } else {
      Cart myCart = Cart(id: user.uid, cartProducts: []);
      orderProduct.quantity = quantity;
      myCart.cartProducts!.add(orderProduct);
      await firestore.updateDocument('cart',user.uid, myCart.toMap());
    }
  }

  

}