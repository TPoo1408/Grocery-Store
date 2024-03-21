part of 'create_order_bloc.dart';

abstract class CreateOrderEvent extends Equatable {
  const CreateOrderEvent();

  @override
  List<Object> get props => [];
}

class CreateOrder extends CreateOrderEvent{
  final Order order;
  const CreateOrder({required this.order});

   @override
  List<Object> get props => [order];
}
