import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/hotel_model.dart';
import '../../models/search_model.dart';
import '../../services/hotel_api.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HotelApi hotelApi;

  HomeBloc({required this.hotelApi}) : super(HomeInitial()) {
    on<FetchHotels>(_onFetchHotels);
    on<AutoCompleteSearchHotels>(_onAutoCompleteSearchHotels);
    on<FetchSearchHotels>(_onFetchSearchHotels);
  }

  Future<void> _onFetchHotels(FetchHotels event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, errorMsg: ''));
    try {
      final List<HotelModel> result = await hotelApi.fetchFeaturedHotels(pageNo: 1);
      emit(state.copyWith(hotels: result, errorMsg: ''));
    } catch (e) {
      emit(state.copyWith(errorMsg: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onAutoCompleteSearchHotels(AutoCompleteSearchHotels event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoadingSearch: true, errorMsg: null));
    try {
      final result = await hotelApi.autoCompleteSearchHotels(query: event.query, pageNo: 1);
      emit(state.copyWith(autoCompleteSearchHotels: result));
      event.reply.complete(result);
    } catch (e) {
      event.reply.completeError(e);
      emit(state.copyWith(autoCompleteSearchHotels: const [], errorMsg: e.toString()));
    } finally {
      emit(state.copyWith(isLoadingSearch: false));
    }
  }

  Future<void> _onFetchSearchHotels(FetchSearchHotels event, Emitter<HomeState> emit) async {
    if (state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true));
    try {
      List<String> nextCursor = state.preLoaderList;
      final items = await hotelApi.searchHotels(
        searchModel: event.searchModel,
        preLoaderList: state.preLoaderList,
        onNextCursor: (c) => nextCursor = c,
      );
      final merged = List<HotelModel>.from(state.searchHotels)..addAll(items);
      final hasMore = items.length == 5;
      emit(state.copyWith(searchHotels: merged, preLoaderList: nextCursor, hasMore: hasMore));
    } catch (e) {
      emit(state.copyWith(autoCompleteSearchHotels: const [], errorMsg: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false, isLoadingMore: false));
    }
  }
}
