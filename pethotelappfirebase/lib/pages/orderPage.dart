import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/navigator.dart';
import '../providers/order_provider.dart';
import '../models/Order.dart' as model; // Use the 'model' prefix here as well

class OrderPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<model.Order>> orders = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('訂單'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color.fromRGBO(255, 239, 239, 1.0),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle effective orders button tap
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Colors.pink),
                  ),
                  child: Text('有效訂單'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle past orders button tap
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  child: Text('過去訂單'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle cancelled orders button tap
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  child: Text('已取消訂單'),
                ),
              ),
            ],
          ),
          Expanded(
            child: orders.when(
              data: (orders) {
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.network(
                              order.imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                // 图片加载失败时显示的Widget
                                return Icon(Icons.error);
                              },
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(order.legalName,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5),
                                  Text(order.serviceType,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  SizedBox(height: 5),
                                  Text(order.formattedDateRange,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  SizedBox(height: 5),
                                  Text(
                                      'Total: \$${order.totalPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          NavigatorPage(), // Replace with your actual bottom navigation bar
    );
  }
}
