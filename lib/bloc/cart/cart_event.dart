part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class UpdateCart extends CartEvent {
  final OrderProduct orderProduct;
  final num quantity;

  const UpdateCart({required this.orderProduct,required this.quantity});
  
  @override
  List<Object> get props => [orderProduct,quantity];
}

class FetchCart extends CartEvent{
  const FetchCart();
}

