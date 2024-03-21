part of 'store_favorite_bloc.dart';

sealed class StoreFavoriteEvent extends Equatable {
  const StoreFavoriteEvent();

  @override
  List<Object> get props => [];
}

class FetchStoreFavorite extends StoreFavoriteEvent{}
