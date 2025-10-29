part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class FetchHotels extends HomeEvent {}

class FetchSearchHotels extends HomeEvent {
  final SearchModel searchModel;

  const FetchSearchHotels({required this.searchModel});
}

class AutoCompleteSearchHotels extends HomeEvent {
  final String query;
  final Completer<List<SearchModel>> reply;

  const AutoCompleteSearchHotels({required this.query, required this.reply});
}
