// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'petshop.dart';

class FirebaseUser {
  final String email;
  final String name;
  final String profilePic;
  final bool isShopOwner; // 新增bool字段
  final List<petShop> shops; // user擁有的店家

  const FirebaseUser({
    required this.email,
    required this.name,
    required this.profilePic,
    required this.isShopOwner,
    required this.shops,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'profilePic': profilePic,
      'isShopOwner': isShopOwner,
      'shops': shops.map((x) => x.toMap()).toList(),
    };
  }

  FirebaseUser copyWith({
    String? email,
    String? name,
    String? profilePic,
    bool? isShopOwner,
    List<petShop>? shops,
  }) {
    return FirebaseUser(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      isShopOwner: isShopOwner ?? this.isShopOwner,
      shops: shops ?? this.shops,
    );
  }

  factory FirebaseUser.fromMap(Map<String, dynamic> map) {
    return FirebaseUser(
      email: map['email'] as String,
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      isShopOwner: map['isShopOwner'] as bool,
      shops: List<petShop>.from(
        (map['shops'] as List<dynamic>).map<petShop>(
          (x) => petShop.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory FirebaseUser.fromJson(String source) =>
      FirebaseUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FirebaseUser(email: $email, name: $name, profilePic: $profilePic, isShopOwner: $isShopOwner, shops: $shops)';
  }

  @override
  bool operator ==(covariant FirebaseUser other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.name == name &&
        other.profilePic == profilePic &&
        other.isShopOwner == isShopOwner &&
        listEquals(other.shops, shops);
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        profilePic.hashCode ^
        isShopOwner.hashCode ^
        shops.hashCode;
  }
}
