part of 'store_favorite_bloc.dart';

abstract class StoreFavoriteState extends Equatable {
  const StoreFavoriteState();
  
  @override
  List<Object> get props => [];
}

class StoreFavoriteInitial extends StoreFavoriteState {}

class StoreFavoriteLoading extends StoreFavoriteState {}

class StoreFavoriteLoaded extends StoreFavoriteState {
  final List<Store> stores;

  const StoreFavoriteLoaded({required this.stores});

  @override
  List<Object> get props => [stores];
}

class StoreFavoriteError extends StoreFavoriteState {
  final String message;

  const StoreFavoriteError({required this.message});

  @override
  List<Object> get props => [message];
}
