import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:store_user/data/models/order.dart';
import 'package:store_user/data/repositories/orders_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersInitial()) {

    final ordersRepository = OrderRepository();

    on<FetchOrders>((event, emit) async {
      emit(OrdersLoading());
      try{
        List<Order> myOrders = await ordersRepository.fetchOrders();
        emit(OrdersLoaded(myOrdersData: myOrders));
      } catch (e){
        emit(OrdersError(message: e.toString()));
      }
    });
  }
}
