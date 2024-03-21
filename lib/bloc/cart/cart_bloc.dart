import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:store_user/data/models/cart.dart';
import 'package:store_user/data/models/order_product.dart';
import 'package:store_user/data/repositories/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    final cartRepository = CartRepository();

    on<FetchCart>((event, emit) async {
      emit(CartLoading());
      try{
        Cart myCart = await cartRepository.fetchCart();
        List<OrderProduct> cartProducts = myCart.cartProducts ?? [];
        emit(CartLoaded(cartProducts: cartProducts));
      } catch (e,s){
        debugPrintStack(label: e.toString(), stackTrace: s);
        emit(CartError(message: e.toString()));
      }
    }
    );

    on<UpdateCart>((event, emit) async{
      try{
        
        await cartRepository.updateCart(event.orderProduct, event.quantity);
        final Cart myCart = await cartRepository.fetchCart();
        print('*** emit ${myCart.cartProducts}' );
        emit(CartLoaded(cartProducts: myCart.cartProducts ?? []));
      }  catch (e,s){
        debugPrintStack(label: e.toString(), stackTrace: s);
        emit(CartError(message: e.toString()));
      }
    });
  }
}
