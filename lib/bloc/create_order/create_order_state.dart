part of 'create_order_bloc.dart';

abstract class CreateOrderState extends Equatable {
  const CreateOrderState();
  
  @override
  List<Object> get props => [];
}

final class CreateOrderInitial extends CreateOrderState {}

final class CreateOrderLoading extends CreateOrderState {}

final class CreateOrderError extends CreateOrderState {
  final String message;
  const CreateOrderError({required this.message});

   @override
  List<Object> get props => [message];
}
final class CreateOrderLoaded extends CreateOrderState {}
