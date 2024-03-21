part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();
  
  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}


class OrdersError extends OrdersState {
  final String message;
  const OrdersError({required this.message});

     @override
  List<Object> get props => [message];
}


class OrdersLoaded extends OrdersState {
  final List<Order> myOrdersData;

  const OrdersLoaded({required this.myOrdersData});

     @override
  List<Object> get props => [myOrdersData];
}

