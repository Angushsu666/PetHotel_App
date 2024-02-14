import 'dart:convert';

class Response {
  final String content;
  final DateTime responseTimestamp;

  Response({
    required this.content,
    required this.responseTimestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'responseTimestamp': responseTimestamp.toIso8601String(),
    };
  }

  factory Response.fromMap(Map<String, dynamic> map) {
    return Response(
      content: map['content'],
      responseTimestamp: DateTime.parse(map['responseTimestamp']),
    );
  }
}

class Review {
  final String author;
  final String content;
  final double rating;
  final DateTime reviewTimestamp;
  final Response? shopResponse;

  Review({
    required this.author,
    required this.content,
    required this.rating,
    required this.reviewTimestamp,
    this.shopResponse,
  });

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'content': content,
      'rating': rating,
      'reviewTimestamp': reviewTimestamp.toIso8601String(),
      'shopResponse': shopResponse?.toMap(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      author: map['author'],
      content: map['content'],
      rating: (map['rating'] as num).toDouble(),
      reviewTimestamp: DateTime.parse(map['reviewTimestamp']),
      shopResponse: map['shopResponse'] != null ? Response.fromMap(map['shopResponse']) : null,
    );
  }
}

class petShop {
  final String id;
  final String legalType;
  final String legalName;
  final String legalAddress;
  final String busItem;
  final String animalType;
  final String validNum;
  final String validDate;
  final String ownName;
  final String bosName;
  final String rankYear;
  final String rankCode;
  final String rankFlag1;
  final String rankFlag2;
  final String rankText;
  final String stateFlag;

  // userid
  final String uid;

  final List<String> album;
  final int price;
  final String introduction;
  final String serviceIntroduction;
  final List<Review> reviews;
  
  // 改为 Map<String, bool> 类型
  final Map<String, bool> roomCollection; 
  final Map<String, bool> foodChoice;
  final Map<String, bool> serviceAndFacilities;
  final Map<String, bool> medicalNeeds;

  petShop({
    required this.id,
    required this.legalType,
    required this.legalName,
    required this.legalAddress,
    required this.busItem,
    required this.animalType,
    required this.validNum,
    required this.validDate,
    required this.ownName,
    required this.bosName,
    required this.rankYear,
    required this.rankCode,
    required this.rankFlag1,
    required this.rankFlag2,
    required this.rankText,
    required this.stateFlag,
    required this.uid,
    required this.album,
    required this.price,
    required this.introduction,
    required this.serviceIntroduction,
    required this.reviews,
    Map<String, bool>? roomCollection,
    Map<String, bool>? foodChoice,
    Map<String, bool>? serviceAndFacilities,
    Map<String, bool>? medicalNeeds,
  })  : this.roomCollection = roomCollection ?? 
            {
              '獨立房型': false,
              '開放式住宿': false,
              '半開放式住宿': false,
            },
        this.foodChoice = foodChoice ?? 
            {
              '鮮食': false,
              '罐頭': false,
              '乾飼料': false,
              '處方飼料': false,
            },
        this.serviceAndFacilities = serviceAndFacilities ?? 
            {
              '24小時監控': false,
              '24小時寵物保姆': false,
              '開放式活動空間': false,
              '游泳池': false,
            },
        this.medicalNeeds = medicalNeeds ?? 
            {
              '口服藥': false,
              '外傷藥': false,
              '陪伴看診': false,
            };

  factory petShop.fromJson(Map<String, dynamic> json) {
    final Map<String, bool> roomCollectionData =
        Map<String, bool>.from(json['roomCollection'] ?? 
            {
              '獨立房型': false,
              '開放式住宿': false,
              '半開放式住宿': false,
            });

    final Map<String, bool> foodChoiceData =
        Map<String, bool>.from(json['foodChoice'] ?? 
            {
              '鮮食': false,
              '罐頭': false,
              '乾飼料': false,
              '處方飼料': false,
            });

    final Map<String, bool> serviceAndFacilitiesData =
        Map<String, bool>.from(json['serviceAndFacilities'] ?? 
            {
              '24小時監控': false,
              '24小時寵物保姆': false,
              '開放式活動空間': false,
              '游泳池': false,
            });

    final Map<String, bool> medicalNeedsData =
        Map<String, bool>.from(json['medicalNeeds'] ?? 
            {
              '口服藥': false,
              '外傷藥': false,
              '陪伴看診': false,
            });
    
    return petShop(
      id: json['ID'],
      legalType: json['legaltype'],
      legalName: json['legalname'],
      legalAddress: json['legaladdress'],
      busItem: json['busitem'],
      animalType: json['animaltype'],
      validNum: json['validnum'],
      validDate: json['validdate'],
      ownName: json['own_name'],
      bosName: json['bos_name'],
      rankYear: json['rank_year'],
      rankCode: json['rank_code'],
      rankFlag1: json['rank_flag_1'],
      rankFlag2: json['rank_flag_2'],
      rankText: json['rank_text'],
      stateFlag: json['state_flag'],
      uid: json['uid'] ?? '',
      album: List<String>.from(json['album'] ?? []),
      price: json['price'] != null ? int.parse(json['price']) : 0,
      introduction: json['introduction'] ?? '',
      serviceIntroduction: json['serviceintroduction'] ?? '',
      roomCollection: roomCollectionData,
      reviews: parseReviews(json['reviews']),
      foodChoice: foodChoiceData,
      serviceAndFacilities: serviceAndFacilitiesData,
      medicalNeeds: medicalNeedsData,
    );
    
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'legalType': legalType,
      'legalName': legalName,
      'legalAddress': legalAddress,
      'busItem': busItem,
      'animalType': animalType,
      'validNum': validNum,
      'validDate': validDate,
      'ownName': ownName,
      'bosName': bosName,
      'rankYear': rankYear,
      'rankCode': rankCode,
      'rankFlag1': rankFlag1,
      'rankFlag2': rankFlag2,
      'rankText': rankText,
      'stateFlag': stateFlag,
      'uid': uid,
      'album': album,
      'price': price,
      'introduction': introduction,
      'serviceintroduction': serviceIntroduction,
      'roomCollection': roomCollection,
      'reviews': reviews.map((review) => review.toMap()).toList(),
      'foodChoice': foodChoice,
      'serviceAndFacilities': serviceAndFacilities,
      'medicalNeeds': medicalNeeds,
    };
  }

  factory petShop.fromMap(Map<String, dynamic> map) {
    final Map<String, bool> roomCollectionData =
        Map<String, bool>.from(map['roomCollection'] ?? {});

    final Map<String, bool> foodChoiceData =
        Map<String, bool>.from(map['foodChoice'] ?? {});

    final Map<String, bool> serviceAndFacilitiesData =
        Map<String, bool>.from(map['serviceAndFacilities'] ?? {});

    final Map<String, bool> medicalNeedsData =
        Map<String, bool>.from(map['medicalNeeds'] ?? {});

    return petShop(
      id: map['id'] as String,
      legalType: map['legalType'] as String,
      legalName: map['legalName'] as String,
      legalAddress: map['legalAddress'] as String,
      busItem: map['busItem'] as String,
      animalType: map['animalType'] as String,
      validNum: map['validNum'] as String,
      validDate: map['validDate'] as String,
      ownName: map['ownName'] as String,
      bosName: map['bosName'] as String,
      rankYear: map['rankYear'] as String,
      rankCode: map['rankCode'] as String,
      rankFlag1: map['rankFlag1'] as String,
      rankFlag2: map['rankFlag2'] as String,
      rankText: map['rankText'] as String,
      stateFlag: map['stateFlag'] as String,
      uid: map['uid'] as String,
      album: List<String>.from(map['album']),
      price: map['price'] as int,
      introduction: map['introduction'] as String,
      serviceIntroduction: map['serviceIntroduction'] as String? ?? '',
      roomCollection: roomCollectionData,
      reviews: parseReviews(map['reviews']),
      foodChoice: foodChoiceData,
      serviceAndFacilities: serviceAndFacilitiesData,
      medicalNeeds: medicalNeedsData,
    );
  }

  String toJson() => json.encode(toMap());

  // 在这里加入 copyWith 方法
  petShop copyWith({
    String? id,
    String? legalType,
    String? legalName,
    String? legalAddress,
    String? busItem,
    String? animalType,
    String? validNum,
    String? validDate,
    String? ownName,
    String? bosName,
    String? rankYear,
    String? rankCode,
    String? rankFlag1,
    String? rankFlag2,
    String? rankText,
    String? stateFlag,
    String? uid,
    List<String>? album,
    int? price,
    String? introduction,
    String? serviceIntroduction,
    List<Review>? reviews,
    Map<String, bool>? roomCollection,
    Map<String, bool>? foodChoice,
    Map<String, bool>? serviceAndFacilities,
    Map<String, bool>? medicalNeeds,
  }) {
    return petShop(
      id: id ?? this.id,
      legalType: legalType ?? this.legalType,
      legalName: legalName ?? this.legalName,
      legalAddress: legalAddress ?? this.legalAddress,
      busItem: busItem ?? this.busItem,
      animalType: animalType ?? this.animalType,
      validNum: validNum ?? this.validNum,
      validDate: validDate ?? this.validDate,
      ownName: ownName ?? this.ownName,
      bosName: bosName ?? this.bosName,
      rankYear: rankYear ?? this.rankYear,
      rankCode: rankCode ?? this.rankCode,
      rankFlag1: rankFlag1 ?? this.rankFlag1,
      rankFlag2: rankFlag2 ?? this.rankFlag2,
      rankText: rankText ?? this.rankText,
      stateFlag: stateFlag ?? this.stateFlag,
      uid: uid ?? this.uid,
      album: album ?? this.album,
      price: price ?? this.price,
      introduction: introduction ?? this.introduction,
      serviceIntroduction: serviceIntroduction ?? this.serviceIntroduction,
      reviews: reviews ?? this.reviews,
      roomCollection: roomCollection ?? this.roomCollection,
      foodChoice: foodChoice ?? this.foodChoice,
      serviceAndFacilities: serviceAndFacilities ?? this.serviceAndFacilities,
      medicalNeeds: medicalNeeds ?? this.medicalNeeds,
    );
  }
}

List<Review> parseReviews(dynamic reviewsJson) {
  if (reviewsJson == null) {
    return [];
  }

  if (reviewsJson is List) {
    return reviewsJson.map((reviewJson) {
      return Review.fromMap(reviewJson);
    }).toList();
  } else {
    return [];
  }
}

int mapHashCode(Map<String, dynamic> map) {
  int hash = 0;
  map.forEach((key, value) {
    hash ^= key.hashCode;
    hash ^= value.hashCode;
  });
  return hash;
}

bool mapEquals(Map<String, dynamic> map1, Map<String, dynamic> map2) {
  if (map1.length != map2.length) {
    return false;
  }
  for (var key in map1.keys) {
    if (map1[key] != map2[key]) {
      return false;
    }
  }
  return true;
}