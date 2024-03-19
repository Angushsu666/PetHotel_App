import 'dart:convert';
import 'package:intl/intl.dart';

class Order {
  final String legalName; //寵物商家名稱
  final String serviceType;
  final DateTime startDate; //預定服務起始日
  final DateTime endDate; //預定服務結束日
  final int totalPrice;  // 将 totalPrice 的类型从 double 改为 int
  final String imageUrl;
  final String tid;  // 交易编号
  final String status;  // 訂單狀態
  final String customerName;  // 客户名
  final String uid;  // 用户ID

  Order({
    required this.legalName,
    required this.serviceType,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,  // totalPrice 现在是 int 类型
    required this.imageUrl,
    required this.tid,
    required this.status,
    required this.customerName,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'legalName': legalName,
      'roomType': serviceType,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalPrice': totalPrice,  // totalPrice 保持为 int 类型，无需改动
      'imageUrl': imageUrl,
      'tid': tid,
      'status': status,
      'customerName': customerName,
      'uid': uid,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      legalName: map['legalName'] ?? '',
      serviceType: map['serviceType'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      totalPrice: map['totalPrice']?.toInt() ?? 0,  // 从 map 中读取时转为 int 类型
      imageUrl: map['imageUrl'] ?? '',
      tid: map['tid'] ?? '',
      status: map['status'] ?? '',
      customerName: map['customerName'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  String get formattedDateRange {
    final startDateFormatted = DateFormat('yyyy年MM月dd日').format(startDate);
    final endDateFormatted = DateFormat('yyyy年MM月dd日').format(endDate);
    return '$startDateFormatted ~ $endDateFormatted';
  }
}
