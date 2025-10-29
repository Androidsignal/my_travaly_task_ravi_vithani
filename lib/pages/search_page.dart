import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc/home_bloc.dart';
import '../constants/app_strings.dart';
import '../models/search_model.dart';
import '../services/hotel_api.dart';
import '../widgets/hotel_card.dart';


class SearchPage extends StatefulWidget {
  final SearchModel? searchModel;

  const SearchPage({super.key, this.searchModel});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late HomeBloc _homeBloc;
  final _sc = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchModel?.valueToDisplay ?? '';
    _homeBloc = HomeBloc(hotelApi: HotelApi());
    if (widget.searchModel != null) _homeBloc.add(FetchSearchHotels(searchModel: widget.searchModel!));

    _sc.addListener(() {
      if (_sc.position.pixels >= _sc.position.maxScrollExtent - 200) {
        if (!_homeBloc.state.isLoadingMore && _homeBloc.state.hasMore) {
          if (widget.searchModel != null) _homeBloc.add(FetchSearchHotels(searchModel: widget.searchModel!));
        }
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    _searchController.dispose();
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_rounded)),
        title: Text(AppStrings.searchResultsTitle),
      ),
      body: BlocProvider.value(
        value: _homeBloc,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.isLoadingMore && state.searchHotels.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.errorMsg.isNotEmpty && state.searchHotels.isEmpty) {
              return Center(child: Text(state.errorMsg));
            }

            if (!state.isLoadingMore && state.searchHotels.isEmpty) {
              return Center(child: Text(AppStrings.noResults));
            }

            final itemCount = state.searchHotels.length + (state.isLoadingMore || state.hasMore ? 1 : 0);

            return ListView.builder(
              controller: _sc,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: itemCount,
              itemBuilder: (context, i) {
                if (i < state.searchHotels.length) {
                  final h = state.searchHotels[i];
                  return HotelCard(hotel: h);
                }
                if (!state.hasMore) return const SizedBox.shrink();
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
