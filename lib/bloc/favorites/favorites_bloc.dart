import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:store_user/data/models/product.dart';
import 'package:store_user/data/repositories/favorites_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial()) {
    final favoritesRepository = FavoritesRepository();
    on<FetchFavorites>((event, emit) async {
      emit(FavoritesLoading());
      try {
        final products = await favoritesRepository.fetchFavoritesProduct();
        emit(FavoritesLoaded(products: products));
      } catch (e, s) {
        debugPrintStack(label: e.toString(), stackTrace: s);
        emit(FavoritesError(message: e.toString()));
      }
    });
  }
}
