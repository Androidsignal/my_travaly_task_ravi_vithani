part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<HotelModel> hotels;
  final List<HotelModel> searchHotels;
  final List<SearchModel> autoCompleteSearchHotels;
  final bool isLoadingSearch;
  final bool isLoading;
  final String errorMsg;

  final List<String> preLoaderList;
  final bool hasMore;
  final bool isLoadingMore;

  const HomeState({
    this.errorMsg = "",
    this.hotels = const [],
    this.isLoadingSearch = false,
    this.isLoading = false,
    this.autoCompleteSearchHotels = const [],
    this.searchHotels = const [],
    this.preLoaderList = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  HomeState copyWith({
    List<HotelModel>? hotels,
    List<HotelModel>? searchHotels,
    bool? isLoadingSearch,
    bool? isLoading,
    List<SearchModel>? autoCompleteSearchHotels,
    String? errorMsg,
    List<String>? preLoaderList,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return HomeState(
      hotels: hotels ?? this.hotels,
      searchHotels: searchHotels ?? this.searchHotels,
      isLoadingSearch: isLoadingSearch ?? this.isLoadingSearch,
      isLoading: isLoading ?? this.isLoading,
      autoCompleteSearchHotels: autoCompleteSearchHotels ?? this.autoCompleteSearchHotels,
      errorMsg: errorMsg ?? this.errorMsg,
      preLoaderList: preLoaderList ?? this.preLoaderList,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [
    hotels,
    isLoadingSearch,
    autoCompleteSearchHotels,
    errorMsg,
    isLoading,
    searchHotels,
    preLoaderList,
    hasMore,
    isLoadingMore,
  ];
}
