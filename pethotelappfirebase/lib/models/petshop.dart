// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Review {
  final String author;
  final String content;
  final int rating;

  Review({
    required this.author,
    required this.content,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'content': content,
      'rating': rating,
    };
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

  //userid
  final String uid;

  final List<String> album; // 新增相片屬性
  final String price; // 新增價位屬性
  final String introduction; // 新增商家介紹屬性
  final String serviceIntroduction; // 新增服務介紹屬性
  final String roomCollection; // 新增房型選擇屬性
  final List<Review> reviews; // 新增評論內容屬性

  // 新增評分屬性

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
    required this.roomCollection,
    required this.reviews,
  });

  factory petShop.fromJson(Map<String, dynamic> json) {
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
      price: json['price'] ?? '',
      introduction: json['introduction'] ?? '',
      serviceIntroduction: json['serviceintroduction'] ?? '',
      roomCollection: json['roomcollection'] ?? '',
      reviews: parseReviews(json['review']),
    );
  }

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
    String? price,
    String? introduction,
    String? serviceIntroduction,
    String? roomCollection,
    List<Review>? reviews,
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
      roomCollection: roomCollection ?? this.roomCollection,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
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
      'roomcollection': roomCollection,
      'reviews': reviews.map((review) => review.toMap()).toList(),
    };
  }

  factory petShop.fromMap(Map<String, dynamic> map) {
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
      price: map['price'] as String,
      introduction: map['introduction'] as String,
      serviceIntroduction: map['serviceIntroduction'] as String,
      roomCollection: map['roomCollection'] as String,
      reviews: parseReviews(map['reviews']),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'petShop(id: $id, legalType: $legalType, legalName: $legalName, legalAddress: $legalAddress, busItem: $busItem, animalType: $animalType, validNum: $validNum, validDate: $validDate, ownName: $ownName, bosName: $bosName, rankYear: $rankYear, rankCode: $rankCode, rankFlag1: $rankFlag1, rankFlag2: $rankFlag2, rankText: $rankText, stateFlag: $stateFlag, uid:$uid ,album: $album, price: $price, introduction: $introduction, serviceIntroduction: $serviceIntroduction, roomCollection: $roomCollection, reviews: $reviews)';
  }

  @override
  bool operator ==(covariant petShop other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.legalType == legalType &&
        other.legalName == legalName &&
        other.legalAddress == legalAddress &&
        other.busItem == busItem &&
        other.animalType == animalType &&
        other.validNum == validNum &&
        other.validDate == validDate &&
        other.ownName == ownName &&
        other.bosName == bosName &&
        other.rankYear == rankYear &&
        other.rankCode == rankCode &&
        other.rankFlag1 == rankFlag1 &&
        other.rankFlag2 == rankFlag2 &&
        other.rankText == rankText &&
        other.stateFlag == stateFlag &&
        other.uid == uid &&
        listEquals(other.album, album) &&
        other.price == price &&
        other.introduction == introduction &&
        other.serviceIntroduction == serviceIntroduction &&
        other.roomCollection == roomCollection &&
        listEquals(other.reviews, reviews);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        legalType.hashCode ^
        legalName.hashCode ^
        legalAddress.hashCode ^
        busItem.hashCode ^
        animalType.hashCode ^
        validNum.hashCode ^
        validDate.hashCode ^
        ownName.hashCode ^
        bosName.hashCode ^
        rankYear.hashCode ^
        rankCode.hashCode ^
        rankFlag1.hashCode ^
        rankFlag2.hashCode ^
        rankText.hashCode ^
        stateFlag.hashCode ^
        uid.hashCode ^
        album.hashCode ^
        price.hashCode ^
        introduction.hashCode ^
        serviceIntroduction.hashCode ^
        roomCollection.hashCode ^
        reviews.hashCode;
  }
}

//您可以在解析時確保屬性值不為 null，如果是 null 則將其轉換成空列表。
List<Review> parseReviews(dynamic reviewsJson) {
  if (reviewsJson == null) {
    return [];
  }

  if (reviewsJson is List) {
    return reviewsJson.map((reviewJson) {
      return Review(
        author: reviewJson['author'] as String,
        content: reviewJson['content'] as String,
        rating: reviewJson['rating'] as int,
      );
    }).toList();
  } else {
    return [];
  }
}
