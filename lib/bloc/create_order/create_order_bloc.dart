import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:store_user/data/models/order.dart';
import 'package:store_user/data/repositories/orders_repository.dart';

part 'create_order_event.dart';
part 'create_order_state.dart';

class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  CreateOrderBloc() : super(CreateOrderInitial()) {

    final orderRepository = OrderRepository();

    on<CreateOrder>((event, emit) async {
        emit(CreateOrderLoading());
        try{
          await orderRepository.createOrder(event.order);
          await orderRepository.clearCart();
          emit(CreateOrderLoaded());
        } catch (e){
          emit(CreateOrderError(message: e.toString()));
        }
    });
  }
}
