import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:store_user/data/models/order_product.dart';

class Cart extends Equatable{
  final String? id;
  List<OrderProduct>? cartProducts;

  Cart({
    this.id,
    this.cartProducts
  });

  Cart copyWith({
    String? id,
    List<OrderProduct>? cartProducts
  }){
    return Cart(
      id: id ?? this.id,
      cartProducts: cartProducts ?? this.cartProducts
    );
  }

  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'id' : id,
      'cartProducts': cartProducts?.map((e) => e.toMap()).toList()
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map){
    return Cart(
      id: map['id'] as String,
      cartProducts: map['cartProducts'] != null ? (map['cartProducts'] as List<dynamic>).map((productMap) {
            return OrderProduct.fromMap(productMap as Map<String, dynamic>);
          }).toList() : null
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      cartProducts,
    ];
  }
}