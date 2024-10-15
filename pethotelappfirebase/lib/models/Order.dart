import 'dart:convert';
import 'package:intl/intl.dart';

//roomType切記要改成serviceType!!
class Order {
  final String userId; //客户名
  final String serviceType;
  final DateTime checkInDate; //預定服務起始日
  final DateTime checkOutDate; //預定服務結束日
  final int totalPrice; // 将 totalPrice 的类型从 double 改为 int
  // final String imageUrl; // Make sure this is properly initialized or handled
  final String tid; // 交易编号
  final String status; // 訂單狀態
  final int numberOfNights;
  final String uid;
  final String petType; // 用户ID
  final String shopId;
  Order({
    required this.userId,
    required this.serviceType,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice,
    // required this.imageUrl,
    required this.tid,
    required this.status,
    required this.numberOfNights,
    required this.uid,
    required this.petType,
    required this.shopId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': userId,
      'serviceType': serviceType,
      'startDate': checkInDate.toIso8601String(),
      'endDate': checkOutDate.toIso8601String(),
      'totalPrice': totalPrice, // totalPrice 保持为 int 类型，无需改动
      // 'imageUrl': imageUrl,
      'tid': tid,
      'status': status,
      'numberOfNights': numberOfNights,
      'uid': uid,
      'petType': petType,
      'shopId': shopId,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      userId: map['userId'] as String? ?? '',
      serviceType: map['serviceType'] as String? ?? '',
      checkInDate: DateTime.parse(map['checkInDate']),
      checkOutDate: DateTime.parse(map['checkOutDate']),
      totalPrice: map['totalPrice']?.toInt() ?? 0, // 从 map 中读取时转为 int 类型
      // imageUrl: map['imageUrl'] ?? '', // Provide a default value if null
      tid: map['tid']as String? ?? '',
      status: map['status'] as String? ?? '',
      numberOfNights:
          map['numberOfNights']?.toInt() ?? 0, // 从 map 中读取时转为 int 类型
      uid: map['uid'] as String? ?? '',
      petType: map['petType'] as String? ?? '',
      shopId: map['shopId']as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  String get formattedDateRange {
    final checkInDateFormatted = DateFormat('yyyy年MM月dd日').format(checkInDate);
    final checkOutDateFormatted =
        DateFormat('yyyy年MM月dd日').format(checkOutDate);
    return '$checkInDateFormatted ~ $checkOutDateFormatted';
  }
}
