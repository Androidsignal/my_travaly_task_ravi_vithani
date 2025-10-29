// models/hotel_model.dart

class HotelModel {
  final String propertyCode;
  final String propertyName;
  final String propertyImage;
  final String propertyType; // note: source key = propertytype
  final int propertyStar;
  final PropertyPoliciesAndAmenities propertyPoliciesAndAmenities;
  final PropertyAddress propertyAddress;
  final String propertyUrl;
  final String roomName;
  final int numberOfAdults;
  final Price markedPrice;
  final Price propertyMaxPrice;
  final Price propertyMinPrice;
  final List<Deal> availableDeals;
  final bool subscriptionStatus;
  final int propertyView;
  final bool isFavorite;
  final SimplPriceList simplPriceList;
  final GoogleReview googleReview;

  HotelModel({
    required this.propertyCode,
    required this.propertyName,
    required this.propertyImage,
    required this.propertyType,
    required this.propertyStar,
    required this.propertyPoliciesAndAmenities,
    required this.propertyAddress,
    required this.propertyUrl,
    required this.roomName,
    required this.numberOfAdults,
    required this.markedPrice,
    required this.propertyMaxPrice,
    required this.propertyMinPrice,
    required this.availableDeals,
    required this.subscriptionStatus,
    required this.propertyView,
    required this.isFavorite,
    required this.simplPriceList,
    required this.googleReview,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) => HotelModel(
    propertyCode: json['propertyCode'] ?? '',
    propertyName: json['propertyName'] ?? '',
    propertyImage: json['propertyImage'] is String
        ? json['propertyImage'] as String
        : (json['propertyImage']?['fullUrl'] ?? ''),
    propertyType: json['propertytype'] ?? '',
    propertyStar: (json['propertyStar'] ?? 0) as int,
    propertyPoliciesAndAmenities: PropertyPoliciesAndAmenities.fromJson(
      json['propertyPoliciesAndAmmenities'] ?? const {},
    ),
    propertyAddress: PropertyAddress.fromJson(json['propertyAddress'] ?? const {}),
    propertyUrl: json['propertyUrl'] ?? '',
    roomName: json['roomName'] ?? '',
    numberOfAdults: (json['numberOfAdults'] ?? 0) as int,
    markedPrice: Price.fromJson(json['markedPrice'] ?? const {}),
    propertyMaxPrice: Price.fromJson(json['propertyMaxPrice'] ?? const {}),
    propertyMinPrice: Price.fromJson(json['propertyMinPrice'] ?? const {}),
    availableDeals: (json['availableDeals'] as List? ?? [])
        .map((e) => Deal.fromJson(e as Map<String, dynamic>))
        .toList(),
    subscriptionStatus: (json['subscriptionStatus']?['status'] ?? false) as bool,
    propertyView: (json['propertyView'] ?? 0) as int,
    isFavorite: (json['isFavorite'] ?? false) as bool,
    simplPriceList: SimplPriceList.fromJson(json['simplPriceList'] ?? const {}),
    googleReview: GoogleReview.fromJson(json['googleReview'] ?? const {}),
  );

  Map<String, dynamic> toJson() => {
    'propertyCode': propertyCode,
    'propertyName': propertyName,
    'propertyImage': propertyImage,
    'propertytype': propertyType,
    'propertyStar': propertyStar,
    'propertyPoliciesAndAmmenities': propertyPoliciesAndAmenities.toJson(),
    'propertyAddress': propertyAddress.toJson(),
    'propertyUrl': propertyUrl,
    'roomName': roomName,
    'numberOfAdults': numberOfAdults,
    'markedPrice': markedPrice.toJson(),
    'propertyMaxPrice': propertyMaxPrice.toJson(),
    'propertyMinPrice': propertyMinPrice.toJson(),
    'availableDeals': availableDeals.map((e) => e.toJson()).toList(),
    'subscriptionStatus': {'status': subscriptionStatus},
    'propertyView': propertyView,
    'isFavorite': isFavorite,
    'simplPriceList': simplPriceList.toJson(),
    'googleReview': googleReview.toJson(),
  };
}


class PropertyPoliciesAndAmenities {
  final bool present;
  final PolicyData? data;

  PropertyPoliciesAndAmenities({required this.present, required this.data});

  factory PropertyPoliciesAndAmenities.fromJson(Map<String, dynamic> json) =>
      PropertyPoliciesAndAmenities(
        present: (json['present'] ?? false) as bool,
        data: json['data'] == null ? null : PolicyData.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
    'present': present,
    'data': data?.toJson(),
  };
}

class PolicyData {
  final String cancelPolicy;
  final String refundPolicy;
  final String childPolicy;
  final String damagePolicy;
  final String propertyRestriction;
  final bool petsAllowed;
  final bool coupleFriendly;
  final bool suitableForChildren;
  final bool bachularsAllowed;
  final bool freeWifi;
  final bool freeCancellation;
  final bool payAtHotel;
  final bool payNow;
  final String lastUpdatedOn;

  PolicyData({
    required this.cancelPolicy,
    required this.refundPolicy,
    required this.childPolicy,
    required this.damagePolicy,
    required this.propertyRestriction,
    required this.petsAllowed,
    required this.coupleFriendly,
    required this.suitableForChildren,
    required this.bachularsAllowed,
    required this.freeWifi,
    required this.freeCancellation,
    required this.payAtHotel,
    required this.payNow,
    required this.lastUpdatedOn,
  });

  factory PolicyData.fromJson(Map<String, dynamic> json) => PolicyData(
    cancelPolicy: json['cancelPolicy'] ?? '',
    refundPolicy: json['refundPolicy'] ?? '',
    childPolicy: json['childPolicy'] ?? '',
    damagePolicy: json['damagePolicy'] ?? '',
    propertyRestriction: json['propertyRestriction'] ?? '',
    petsAllowed: (json['petsAllowed'] ?? false) as bool,
    coupleFriendly: (json['coupleFriendly'] ?? false) as bool,
    suitableForChildren: (json['suitableForChildren'] ?? false) as bool,
    bachularsAllowed: (json['bachularsAllowed'] ?? false) as bool,
    freeWifi: (json['freeWifi'] ?? false) as bool,
    freeCancellation: (json['freeCancellation'] ?? false) as bool,
    payAtHotel: (json['payAtHotel'] ?? false) as bool,
    payNow: (json['payNow'] ?? false) as bool,
    lastUpdatedOn: json['lastUpdatedOn'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'cancelPolicy': cancelPolicy,
    'refundPolicy': refundPolicy,
    'childPolicy': childPolicy,
    'damagePolicy': damagePolicy,
    'propertyRestriction': propertyRestriction,
    'petsAllowed': petsAllowed,
    'coupleFriendly': coupleFriendly,
    'suitableForChildren': suitableForChildren,
    'bachularsAllowed': bachularsAllowed,
    'freeWifi': freeWifi,
    'freeCancellation': freeCancellation,
    'payAtHotel': payAtHotel,
    'payNow': payNow,
    'lastUpdatedOn': lastUpdatedOn,
  };
}

class PropertyAddress {
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipcode;
  final String mapAddress;
  final double latitude;
  final double longitude;

  PropertyAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipcode,
    required this.mapAddress,
    required this.latitude,
    required this.longitude,
  });

  factory PropertyAddress.fromJson(Map<String, dynamic> json) => PropertyAddress(
    street: json['street'] ?? '',
    city: json['city'] ?? '',
    state: json['state'] ?? '',
    country: json['country'] ?? '',
    zipcode: json['zipcode'] ?? '',
    mapAddress: (json['mapAddress'] ?? json['map_address'] ?? '') as String,
    latitude: _toDouble(json['latitude']),
    longitude: _toDouble(json['longitude']),
  );

  Map<String, dynamic> toJson() => {
    'street': street,
    'city': city,
    'state': state,
    'country': country,
    'zipcode': zipcode,
    'mapAddress': mapAddress,
    'latitude': latitude,
    'longitude': longitude,
  };
}

class Price {
  final double amount;
  final String displayAmount;
  final String currencyAmount;
  final String currencySymbol;

  Price({
    required this.amount,
    required this.displayAmount,
    required this.currencyAmount,
    required this.currencySymbol,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    amount: _toDouble(json['amount']),
    displayAmount: json['displayAmount'] ?? '',
    currencyAmount: json['currencyAmount'] ?? '',
    currencySymbol: json['currencySymbol'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'displayAmount': displayAmount,
    'currencyAmount': currencyAmount,
    'currencySymbol': currencySymbol,
  };
}

class Deal {
  final String headerName;
  final String websiteUrl;
  final String dealType;
  final Price price;

  Deal({
    required this.headerName,
    required this.websiteUrl,
    required this.dealType,
    required this.price,
  });

  factory Deal.fromJson(Map<String, dynamic> json) => Deal(
    headerName: json['headerName'] ?? '',
    websiteUrl: json['websiteUrl'] ?? '',
    dealType: json['dealType'] ?? '',
    price: Price.fromJson(json['price'] ?? const {}),
  );

  Map<String, dynamic> toJson() => {
    'headerName': headerName,
    'websiteUrl': websiteUrl,
    'dealType': dealType,
    'price': price.toJson(),
  };
}

class SimplPriceList {
  final Price simplPrice;
  final double originalPrice;

  SimplPriceList({
    required this.simplPrice,
    required this.originalPrice,
  });

  factory SimplPriceList.fromJson(Map<String, dynamic> json) => SimplPriceList(
    simplPrice: Price.fromJson(json['simplPrice'] ?? const {}),
    originalPrice: _toDouble(json['originalPrice']),
  );

  Map<String, dynamic> toJson() => {
    'simplPrice': simplPrice.toJson(),
    'originalPrice': originalPrice,
  };
}

class GoogleReview {
  final bool reviewPresent;
  final GoogleReviewData? data;

  GoogleReview({required this.reviewPresent, required this.data});

  factory GoogleReview.fromJson(Map<String, dynamic> json) => GoogleReview(
    reviewPresent: (json['reviewPresent'] ?? false) as bool,
    data: json['data'] == null ? null : GoogleReviewData.fromJson(json['data']),
  );

  Map<String, dynamic> toJson() => {
    'reviewPresent': reviewPresent,
    'data': data?.toJson(),
  };
}

class GoogleReviewData {
  final double overallRating;
  final int totalUserRating;
  final int withoutDecimal;

  GoogleReviewData({
    required this.overallRating,
    required this.totalUserRating,
    required this.withoutDecimal,
  });

  factory GoogleReviewData.fromJson(Map<String, dynamic> json) => GoogleReviewData(
    overallRating: _toDouble(json['overallRating']),
    totalUserRating: (json['totalUserRating'] ?? 0) as int,
    withoutDecimal: (json['withoutDecimal'] ?? 0) as int,
  );

  Map<String, dynamic> toJson() => {
    'overallRating': overallRating,
    'totalUserRating': totalUserRating,
    'withoutDecimal': withoutDecimal,
  };
}

double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}
