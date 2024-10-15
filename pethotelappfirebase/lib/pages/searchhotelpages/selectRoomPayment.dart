import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'dart:convert'; // 用于json编码和解码
import 'package:http/http.dart' as http; // 用于发送HTTP请求

// 请确保您的模型和提供者已正确设置
import '../../providers/user_provider.dart';
import '../../models/petshop.dart';
import 'selectRoomPaymentWebview.dart';

class SelectRoomPaymentPage extends ConsumerWidget {
  final petShop shop; // 确保PetShop是您模型的正确名称
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int numberOfNights;
  final int totalPrice;
  final String serviceType;
  final String petType;

  const SelectRoomPaymentPage({super.key, 
    required this.shop,
    this.checkInDate,
    this.checkOutDate,
    required this.numberOfNights,
    required this.totalPrice,
    required this.serviceType,
    required this.petType,
  });

  Future<void> launchECPayPayment(BuildContext context, WidgetRef ref) async {
    // 獲取當前用戶信息
    LocalUser currentUser = ref.read(userProvider);
    print("currentUser.id:${currentUser.id}");
    print("totalPrice:");
    print(totalPrice);
    // 訂單數據
    Map<String, dynamic> orderData = {
      //九樣
      'userId': currentUser.user.name,
      'uid': currentUser.id,
      'shopId': shop.id,     
      'checkInDate': checkInDate?.toIso8601String(), // ISO8601字符串格式
      'checkOutDate': checkOutDate?.toIso8601String(),
      'numberOfNights': numberOfNights,
      'totalPrice': totalPrice,
      'serviceType': serviceType, //可以改嗎？
      'petType' : petType,
    };

    // 創建訂單的 API 端點
    String createOrderUrl =
        'https://petserviceapp-e7f33755e1c3.herokuapp.com/create_order';
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
          const SnackBar(content: Text('创建订单失败，请重试')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('出现错误，请重试')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.read(userProvider); // 获取当前用户信息

    return Scaffold(
      appBar: AppBar(
        title: const Text('付款信息'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('個人資料'),
              subtitle: Text(
                '姓名: ${currentUser.user.name}\n電話: ${currentUser.user.phone}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('商家：'),
              subtitle: Text(shop.legalName),
            ),
            ListTile(
              title: const Text('房型：'),
              subtitle: Text(serviceType),
            ),
            ListTile(
              title: const Text('寵物類型：'),
              subtitle: Text(petType),
            ),
            const Divider(),
            ListTile(
              title: const Text('入住日期'),
              subtitle: Text(
                DateFormat('MM月dd日 EEEE', 'zh_CN').format(checkInDate!),
                style:
                    const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
              ),
            ),
            ListTile(
              title: const Text('退房日期'),
              subtitle: Text(
                DateFormat('MM月dd日 EEEE', 'zh_CN').format(checkOutDate!),
                style:
                    const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '總費用：${totalPrice.toStringAsFixed(0)} TWD',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () => launchECPayPayment(context, ref),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('建立訂單', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
