import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert'; // 用于json编码和解码
import 'package:http/http.dart' as http; // 用于发送HTTP请求

// 请确保您的模型和提供者已正确设置
import '../providers/user_provider.dart';
import '../models/petshop.dart';
import 'selectRoomPaymentWebview.dart';

class SelectRoomPaymentPage extends ConsumerWidget {
  final petShop shop; // 确保PetShop是您模型的正确名称
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int numberOfNights;
  final int totalPrice;
  final String roomType;

  SelectRoomPaymentPage({
    required this.shop,
    this.checkInDate,
    this.checkOutDate,
    required this.numberOfNights,
    required this.totalPrice,
    required this.roomType,
  });

  Future<void> launchECPayPayment(BuildContext context, WidgetRef ref) async {
    // 獲取當前用戶信息
    LocalUser currentUser = ref.read(userProvider);
    print("currentUser.id:" + currentUser.id);
    print("totalPrice:" );
    print(totalPrice);
    // 訂單數據
    Map<String, dynamic> orderData = {
      'userId': currentUser.user.name,
      'uid': currentUser.id,
      'shopId': shop.id, //寵物商家的id
      'checkInDate': checkInDate?.toIso8601String(), // ISO8601字符串格式
      'checkOutDate': checkOutDate?.toIso8601String(),
      'numberOfNights': numberOfNights,
      'totalPrice': totalPrice,
      'roomType': roomType,
    };

    // 創建訂單的 API 端點
    String createOrderUrl = 'https://petserviceapp-e7f33755e1c3.herokuapp.com/create_order';
    //實際的api:https://petserviceapp-e7f33755e1c3.herokuapp.com/create_order
    //測試用的：http://127.0.0.1:5000/create_order
    // 發送 HTTP POST 請求到後端
    try {
      // 发送请求到后端创建订单
      final response = await http.post(
        Uri.parse(createOrderUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );

      if (response.statusCode == 200) {
        // 解析响应数据以获取支付URL
        final responseData = json.decode(response.body);
        final String paymentHtmlContent =
            responseData['paymentHtmlContent']; // 确保这一行没有拼写错误

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentWebViewPage(
                paymentHtmlContent:
                    paymentHtmlContent), // 这里传递 paymentHtmlContent 给 PaymentWebViewPage
          ),
        );
      } else {
        // 处理错误响应
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('创建订单失败，请重试')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('出现错误，请重试')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.read(userProvider); // 获取当前用户信息

    return Scaffold(
      appBar: AppBar(
        title: Text('付款信息'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('個人资料'),
              subtitle: Text(
                '姓名: ${currentUser.user.name}\nPhone: ${currentUser.user.phone}',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Divider(),
            ListTile(
              title: Text('商家：'),
              subtitle: Text(shop.legalName),
            ),
            ListTile(
              title: Text('房型：'),
              subtitle: Text(roomType),
            ),
            Divider(),
            ListTile(
              title: Text('入住日期'),
              subtitle: Text(
                DateFormat('MM月dd日 EEEE', 'zh_CN').format(checkInDate!),
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
              ),
            ),
            ListTile(
              title: Text('退房日期'),
              subtitle: Text(
                DateFormat('MM月dd日 EEEE', 'zh_CN').format(checkOutDate!),
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
              ),
            ),
            Divider(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '總費用：${totalPrice.toStringAsFixed(0)} TWD',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () => launchECPayPayment(context, ref),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text('建立訂單', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
