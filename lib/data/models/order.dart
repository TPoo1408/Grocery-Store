import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:store_user/data/models/order_product.dart';

class Order extends Equatable {
  final String id;
  final List<OrderProduct> products;
  final DateTime createdAt;
  final double total;


  const Order({
    required this.id,
    required this.total,
    required this.products,
    required this.createdAt,

  });

  Order copyWith({
    String? id,
    double? total,
    List<OrderProduct>? products,
    DateTime? createdAt,

  }) {
    return Order(
      id: id ?? this.id,
      total: total ?? this.total,
      products: products ?? this.products,
      createdAt: createdAt ?? this.createdAt,
 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'products': products.map((e) => e.toMap()).toList(),
      'createdAt': createdAt,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      total: map['total'] as double,
      products: (map['products'] as List<dynamic>).map((e)
       => OrderProduct.fromMap(e as Map<String,dynamic>)).toList(),
      createdAt: map['createdAt'].toDate(),

    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        total,
        products,
        createdAt,
      ];
}
