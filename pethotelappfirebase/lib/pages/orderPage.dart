import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/navigator.dart';
import '../providers/order_provider.dart';
import '../models/Order.dart' as model;
import '../providers/user_provider.dart';
import '../providers/shop_provider.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({super.key});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
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
    print('currentUser: ${currentUser.user.phone}');
    Future<void> printShopId() async {
      final shop =
          await ref.read(shopsProvider.notifier).getShopData(currentUser);
      print('shop.id: ${shop.id}');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('訂單'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color.fromRGBO(255, 239, 239, 1.0),
      ),
      body: Column(
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
                child: const Text('有效訂單'),
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
            ]
          ),
          // Displaying the filtered orders
          Expanded(
            child: orders.when(
              data: (allOrders) {
                // Filter orders by current user and status
                List<model.Order> filteredOrders = allOrders
                    .where((order) =>
                        order.userId == currentUser.user.name &&
                        order.status == currentStatus)
                    .toList();
                
                return ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      model.Order order = filteredOrders[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('商家名稱:${order.shopId}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
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
                            ],
                          ),
                        ),
                      );
                    });
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavigatorPage(),
    );
  }
}
