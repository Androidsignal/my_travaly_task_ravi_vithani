import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/home_bloc/home_bloc.dart';
import '../constants/app_strings.dart';
import '../models/search_model.dart';
import '../services/hotel_api.dart';
import '../widgets/hotel_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc _homeBloc;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(hotelApi: HotelApi());
    _homeBloc.add(FetchHotels());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hotelImages = [
      'assets/Home1.jpg',
      'assets/Home2.jpg',
      'assets/Home3.jpg',
      'assets/Home4.jpg',
      'assets/Home5.jpg',
      'assets/Home6.jpg',
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12, right: 0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage('assets/logov1.png')),
            ),
          ),
        ),
        titleSpacing: 10,
        actions: [
          BlocListener(
            bloc: context.read<AuthBloc>(),
            listener: (context, state) {
              if (state is AuthInitial) {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  context.read<AuthBloc>().add(AuthSignOut());
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(value: 'logout', child: Text(AppStrings.logout)),
              ],
            ),
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _homeBloc,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(hotelImages[Random().nextInt(hotelImages.length)]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Color(0x66000000),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Text(
                        AppStrings.findEpicHeadline,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.black54)],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 50),
                      Text(
                        AppStrings.heroSubtitle,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.black54)],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 50),
                      TypeAheadField<SearchModel>(
                        suggestionsCallback: (search) {
                          if (search.trim().length < 3) return Future.value(const []);
                          final c = Completer<List<SearchModel>>();
                          _homeBloc.add(AutoCompleteSearchHotels(query: search, reply: c));
                          return c.future;
                        },
                        hideWithKeyboard: false,
                        hideOnUnfocus: false,
                        hideKeyboardOnDrag: false,
                        showOnFocus: true,
                        hideOnEmpty: true,
                        hideOnSelect: true,
                        controller: _searchController,
                        builder: (context, controller, focusNode) {
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            onFieldSubmitted: (value) {},
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: Icon(Icons.location_on_rounded, color: Color(0xffff6f62)),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close, color: Colors.grey),
                                      onPressed: () {
                                        _searchController.clear();
                                        FocusScope.of(context).unfocus();
                                      },
                                    )
                                  : null,
                              hintText: AppStrings.searchHint,
                              hintStyle: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(color: Theme.of(context).hintColor),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Color(0xffff6f62), width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Color(0xffff6f62), width: 1.0),
                              ),
                            ),
                          );
                        },
                        itemSeparatorBuilder: (context, index) => Divider(height: 1),
                        itemBuilder: (context, hotel) {
                          return ListTile(
                            title: Text(hotel.valueToDisplay),
                            subtitle: Text(
                              [hotel.city, hotel.state, hotel.country].where((e) => e.trim().isNotEmpty).join(', '),
                            ),
                          );
                        },
                        onSelected: (searchModel) {
                          Navigator.of(context).pushNamed('/search', arguments: searchModel);
                        },
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffff6f62),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                          ),
                          child: Text(
                            AppStrings.search,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Text(
                      AppStrings.hotelsAtYourConvenienceTitle,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      AppStrings.hotelsAtYourConvenienceDesc,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        return ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: state.hotels.length,
                          itemBuilder: (_, i) => HotelCard(hotel: state.hotels[i]),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
