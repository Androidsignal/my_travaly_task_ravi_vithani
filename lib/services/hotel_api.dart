import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_travaly_task/models/search_model.dart';
import 'package:my_travaly_task/services/prefs.dart';
import '../constants/app_strings.dart';
import '../models/hotel_model.dart';
import 'package:intl/intl.dart';

class HotelApi {
  // Change endpoint/params here if the API contract differs.
  static const Duration _requestTimeout = Duration(seconds: 10);

  Future<List<HotelModel>> fetchFeaturedHotels({required int pageNo}) async {
    String? visitorToken = await Prefs.getVisitorToken();

    if (visitorToken == null) {
      throw Exception('Visitor token not found. User might not be authenticated.');
    }

    final body = {
      "action": "popularStay",
      "popularStay": {
        "limit": 10,
        "entityType": "Any",
        "currency": "INR",
        "page": pageNo,
        "filter": {
          "searchType": "byRandom", //byCity, byState, byCountry, byRandom,
          "searchTypeInfo": {"country": "India", "state": "Gujarat", "city": "Surat"},
        },
      },
    };

    late http.Response res;
    try {
      res = await http
          .post(
            Uri.parse(AppStrings.baseUrl),
            headers: {'Accept': 'application/json', 'authtoken': AppStrings.authToken, 'visitortoken': visitorToken},
            body: jsonEncode(body),
          )
          .timeout(_requestTimeout);
    } on TimeoutException catch (_) {
      throw Exception('Request timed out while fetching featured hotels.');
    }

    if (res.statusCode != 200) {
      throw Exception('Fetch featured hotels failed: ${res.statusCode} ${res.body}');
    }

    var respBody = jsonDecode(res.body);

    final items = ((respBody as Map)['data'] as List).map((e) => HotelModel.fromJson((e as Map).cast())).toList();

    return items;
  }

  Future<List<HotelModel>> searchHotels({
    List<String> preLoaderList = const [],
    required SearchModel searchModel,
    void Function(List<String> nextPreloaderList)? onNextCursor,
  }) async {
    final visitorToken = await Prefs.getVisitorToken();
    if (visitorToken == null) throw Exception('Visitor token not found.');

    final now = DateTime.now();
    final checkIn = DateFormat('yyyy-MM-dd').format(now);
    final checkOut = DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 1)));

    const limit = 5;

    final body = {
      "action": "getSearchResultListOfHotels",
      "getSearchResultListOfHotels": {
        "searchCriteria": {
          "checkIn": checkIn,
          "checkOut": checkOut,
          "rooms": 1,
          "adults": 1,
          "children": 0,
          "searchType": searchModel.searchArray.type,
          "searchQuery": searchModel.searchArray.query,
          "accommodation": ["all", "hotel"],
          // "arrayOfExcludedSearchType": ["street"],
          "highPrice": "3000000",
          "lowPrice": "0",
          "limit": limit,
          "preloaderList": preLoaderList,
          "currency": "INR",
          "rid": 0,
        },
      },
    };

    late http.Response res;
    try {
      res = await http
          .post(
            Uri.parse(AppStrings.baseUrl),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'authtoken': AppStrings.authToken,
              'visitortoken': visitorToken,
            },
            body: jsonEncode(body),
          )
          .timeout(_requestTimeout);
    } on TimeoutException catch (_) {
      throw Exception('Request timed out while searching hotels.');
    }

    if (res.statusCode != 200) {
      throw Exception('Fetch hotels failed: ${res.statusCode} ${res.body}');
    }

    final Map<String, dynamic> resp = jsonDecode(res.body);
    final Map<String, dynamic> data = (resp['data'] as Map<String, dynamic>? ?? {});

    // parse list
    final List<dynamic> arr = (data['arrayOfHotelList'] as List<dynamic>? ?? []);
    final items = arr.map((e) => HotelModel.fromJson((e as Map).cast())).toList();

    // get next preLoaderList from API (preferred)
    List<String> nextPre;
    if (data['arrayOfExcludedHotels'] is List) {
      nextPre = (data['arrayOfExcludedHotels'] as List).map((e) => e.toString()).toList();
    } else {
      // fallback: append returned property codes to existing preloader list
      final appended = <String>{...preLoaderList, ...items.map((h) => h.propertyCode)};
      nextPre = appended.toList();
    }

    // pass cursor to caller
    onNextCursor?.call(nextPre);

    return items;
  }

  Future<List<SearchModel>> autoCompleteSearchHotels({required String query, required int pageNo}) async {
    String? visitorToken = await Prefs.getVisitorToken();
    if (visitorToken == null) {
      throw Exception('Visitor token not found. User might not be authenticated.');
    }

    final body = {
      "action": "searchAutoComplete",
      "searchAutoComplete": {
        "inputText": query,
        "searchType": [
          "byCity",
          "byState",
          "byCountry",
          "byRandom",
          "byPropertyName", // you can put any searchType from the list
        ],
        "limit": 10,
      },
    };

    late http.Response res;
    try {
      res = await http
          .post(
            Uri.parse(AppStrings.baseUrl),
            headers: {'Accept': 'application/json', 'authtoken': AppStrings.authToken, 'visitortoken': visitorToken},
            body: jsonEncode(body),
          )
          .timeout(_requestTimeout);
    } on TimeoutException catch (_) {
      throw Exception('Request timed out while fetching autocomplete suggestions.');
    }

    if (res.statusCode != 200) {
      throw Exception('Fetch featured hotels failed: ${res.statusCode} ${res.body}');
    }

    var respBody = jsonDecode(res.body);

    final results = <Map<String, dynamic>>[];

    try {
      final data = respBody['data'];
      if (data != null && data is Map<String, dynamic>) {
        final autoComplete = data['autoCompleteList'];
        if (autoComplete != null && autoComplete is Map<String, dynamic>) {
          autoComplete.forEach((key, value) {
            if (value is Map && (value['present'] == true)) {
              final list = value['listOfResult'];
              if (list is List) {
                for (final item in list) {
                  if (item is Map<String, dynamic>) results.add(item);
                }
              }
            }
          });
        }
      }
    } catch (_) {
      // keep results empty on parse errors; caller will handle empty list
    }

    final items = results.map((e) => SearchModel.fromJson((e as Map).cast())).toList();

    return items;
  }
}
