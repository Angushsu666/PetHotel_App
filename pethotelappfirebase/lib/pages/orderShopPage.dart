import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/navigator.dart';
import '../providers/order_provider.dart';
import '../models/Order.dart' as model;
import '../models/petshop.dart';
import '../providers/user_provider.dart';
import '../providers/shop_provider.dart';

class OrderShopPage extends ConsumerStatefulWidget {
  const OrderShopPage({super.key});

  @override
  _OrderShopPageState createState() => _OrderShopPageState();
}

class _OrderShopPageState extends ConsumerState<OrderShopPage> {
  String currentStatus = '交易成功'; // Default to show effective orders

  void updateStatus(String newStatus) {
    setState(() {
      currentStatus = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<model.Order>> orders = ref.watch(orderProvider);
    LocalUser currentUser = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('訂單'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color.fromRGBO(255, 239, 239, 1.0),
      ),
      body: FutureBuilder<petShop>(
        future: ref.read(shopsProvider.notifier).getShopData(currentUser),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text("錯誤: ${snapshot.error}");
          }
          //不要顯示error，顯示內容為中文！！！！！！！！！！
          petShop shop = snapshot.data!;

          return Column(
            children: [
              // Buttons for switching between order types
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => updateStatus('交易成功'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentStatus == '交易成功'
                          ? const Color.fromRGBO(255, 239, 239, 1.0)
                          : Colors.grey,
                    ),
                    child: const Text('已完成訂單'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => updateStatus('未支付'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentStatus == '未支付'
                          ? const Color.fromRGBO(255, 239, 239, 1.0)
                          : Colors.grey,
                    ),
                    child: const Text('未完成訂單'),
                  ),
                ],
              ),
              // Displaying the filtered orders 給用戶的
              Expanded(
                child: orders.when(
                  data: (allOrders) {
                    // Filter orders by current user and status
                    List<model.Order> filteredOrders = allOrders
                        .where((order) =>
                            order.shopId == shop.id &&
                            order.status == currentStatus)
                        .toList();

                    return ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          model.Order order = filteredOrders[index];

                          // Check if the order's shopId matches the current shop's id

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Display either the shop name or the owner name
                                  Text(
                                    '飼主名稱:${order.userId}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Other details here
                                  const SizedBox(height: 5),
                                  Text('${order.serviceType}/ ${order.petType}',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  const SizedBox(height: 5),
                                  Text(order.formattedDateRange,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  const SizedBox(height: 5),
                                  Text('總價: ${order.totalPrice} 元',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  loading: () => Container(
                    color: const Color.fromRGBO(255, 239, 239, 1.0), // 设置背景色
                    child: Center(
                      child: Image.asset(
                        'assets/logo3.png',
                        width: 150.0,
                        height: 150.0,
                      ), //
                    ),
                  ),
                  error: (err, stack) => Text('Error: $err'),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const NavigatorPage(),
    );
  }
}
