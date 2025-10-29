class SearchModel {
  final String valueToDisplay;
  final String city;
  final String state;
  final String country;
  final SearchArrayModel searchArray;

  SearchModel({
    required this.valueToDisplay,
    required this.city,
    required this.state,
    required this.country,
    required this.searchArray,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      valueToDisplay: json['valueToDisplay'],
      city: json['address'] != null && json['address'].containsKey('city') ? json['address']['city'] : '',
      state: json['address'] != null && json['address'].containsKey('state') ? json['address']['state'] : '',
      country: json['address'] != null && json['address'].containsKey('country') ? json['address']['country'] : '',
      searchArray: json['searchArray'] != null
          ? SearchArrayModel.fromJson((json['searchArray'] as Map).cast())
          : SearchArrayModel(type: '', query: []),
    );
  }
}

class SearchArrayModel {
  final String type;
  final List<String> query;

  SearchArrayModel({required this.type, required this.query});

  factory SearchArrayModel.fromJson(Map<String, dynamic> json) {
    return SearchArrayModel(type: json['type'], query: json['query'] != null ? List<String>.from(json['query']) : []);
  }
}
