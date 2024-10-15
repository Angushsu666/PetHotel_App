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
      shopResponse: map['shopResponse'] != null
          ? Response.fromMap(map['shopResponse'])
          : null,
    );
  }

  // 添加 copyWith 方法
  Review copyWith({
    String? author,
    String? content,
    double? rating,
    DateTime? reviewTimestamp,
    Response? shopResponse,
  }) {
    return Review(
      author: author ?? this.author,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      reviewTimestamp: reviewTimestamp ?? this.reviewTimestamp,
      shopResponse: shopResponse ?? this.shopResponse,
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
  //住宿
  final Map<String, Map<String, int>> roomCollection;
  final Map<String, bool> foodChoice;
  final Map<String, bool> serviceAndFacilities;
  final Map<String, bool> medicalNeeds;
  //寵物美容
  final Map<String, Map<String, int>> petGrooming;

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
    Map<String, Map<String, int>>? roomCollection,
    Map<String, bool>? foodChoice,
    Map<String, bool>? serviceAndFacilities,
    Map<String, bool>? medicalNeeds,
    Map<String, Map<String, int>>? petGrooming,
  })  : roomCollection = roomCollection ??
            {
              '獨立房型': {'小型犬': 0, '中型犬': 0, '大型犬': 0, '貓': 0},
              '開放式住宿': {'小型犬': 0, '中型犬': 0, '大型犬': 0, '貓': 0},
              '半開放式住宿': {'小型犬': 0, '中型犬': 0, '大型犬': 0, '貓': 0},
            },
        foodChoice = foodChoice ??
            {
              '鮮食': false,
              '罐頭': false,
              '乾飼料': false,
              '處方飼料': false,
            },
        serviceAndFacilities = serviceAndFacilities ??
            {
              '24小時監控': false,
              '24小時寵物保姆': false,
              '開放式活動空間': false,
              '游泳池': false,
            },
        medicalNeeds = medicalNeeds ??
            {
              '口服藥': false,
              '外傷藥': false,
              '陪伴看診': false,
            },
        petGrooming = petGrooming ??
            {
              '小美容': {'小型犬': 0, '中型犬': 0, '大型犬': 0, '貓': 0},
              '大美容': {'小型犬': 0, '中型犬': 0, '大型犬': 0, '貓': 0},
            };

  factory petShop.fromJson(Map<String, dynamic> json) {
    final roomCollectionJson =
        json['roomCollection'] as Map<String, dynamic>? ?? {};

    // 使用 .map() 转换每个字段的值，确保使用正确的类型
    final roomCollection = roomCollectionJson
        .map((key, value) => MapEntry(key, Map<String, int>.from(value)));

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
    final petGroomingJson =
        json['roomCollection'] as Map<String, dynamic>? ?? {};

    // 使用 .map() 转换每个字段的值，确保使用正确的类型
    final petGrooming = petGroomingJson
        .map((key, value) => MapEntry(key, Map<String, int>.from(value)));
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
      reviews: parseReviews(json['reviews']),
      roomCollection: roomCollection,
      foodChoice: foodChoiceData,
      serviceAndFacilities: serviceAndFacilitiesData,
      medicalNeeds: medicalNeedsData,
      petGrooming: petGrooming,
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
      'reviews': reviews.map((review) => review.toMap()).toList(),
      'roomCollection': roomCollection,
      'foodChoice': foodChoice,
      'serviceAndFacilities': serviceAndFacilities,
      'medicalNeeds': medicalNeeds,
      'petGrooming': petGrooming,
    };
  }

  factory petShop.fromMap(Map<String, dynamic> map) {
    // 确保 roomCollection 不为空，如果为空则使用默认值
    final roomCollectionJson = map['roomCollection'] as Map<String, dynamic>? ??
        {
          '獨立房型': {'小型犬': 0, '中型犬': 0, '大型犬': 0, '貓': 0},
          '開放式住宿': {'小型犬': 0, '中型犬': 0, '大型犬': 0, '貓': 0},
          '半開放式住宿': {'小型犬': 0, '中型犬': 0, '大型犬': 0, '貓': 0},
        };
    // 使用 .map() 转换各个字段的值
    final roomCollection = roomCollectionJson
        .map((key, value) => MapEntry(key, Map<String, int>.from(value)));
    final Map<String, bool> foodChoiceData =
        Map<String, bool>.from(map['foodChoice'] ?? {});

    final Map<String, bool> serviceAndFacilitiesData =
        Map<String, bool>.from(map['serviceAndFacilities'] ?? {});

    final Map<String, bool> medicalNeedsData =
        Map<String, bool>.from(map['medicalNeeds'] ?? {});

    final petGroomingJson = map['petGrooming'] as Map<String, dynamic>? ??
        {
          '小美容': {'小型犬': 0, '中型犬': 0, '大型犬': 0, '貓': 0},
          '大美容': {'小型犬': 0, '中型犬': 0, '大型犬': 0, '貓': 0},
        };
    final petGrooming = petGroomingJson
        .map((key, value) => MapEntry(key, Map<String, int>.from(value)));
    // 返回 pet
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
      reviews: parseReviews(map['reviews']),
      roomCollection: roomCollection,
      foodChoice: foodChoiceData,
      serviceAndFacilities: serviceAndFacilitiesData,
      medicalNeeds: medicalNeedsData,
      petGrooming: petGrooming,
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
    Map<String, Map<String, int>>? roomCollection,
    Map<String, bool>? foodChoice,
    Map<String, bool>? serviceAndFacilities,
    Map<String, bool>? medicalNeeds,
    Map<String, Map<String, int>>? petGrooming,
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
      petGrooming: petGrooming ?? this.petGrooming,
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
