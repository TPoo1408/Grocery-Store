import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:store_user/data/models/store.dart';
import 'package:store_user/data/repositories/favorites_repository.dart';

part 'store_favorite_event.dart';
part 'store_favorite_state.dart';

class StoreFavoriteBloc extends Bloc<StoreFavoriteEvent, StoreFavoriteState> {
  StoreFavoriteBloc() : super(StoreFavoriteInitial()) {
    final favoriteRepository = FavoritesRepository();

    on<FetchStoreFavorite>((event, emit) async {
      emit(StoreFavoriteLoading());
      try{
        final stores = await favoriteRepository.fetchFavoritesStore();
        emit(StoreFavoriteLoaded(stores: stores));
      } catch(e){
        emit(StoreFavoriteError(message: e.toString()));
      }
    });
  }
}
