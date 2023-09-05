import 'package:flutter/material.dart';
import '../components/navigator.dart';

//有效訂單介面：選擇房型後有付款的。
class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OrderPage'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color.fromARGB(255, 226, 160, 182), // 更改AppBar的背景顏色
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // 處理有效訂單按鈕的點擊事件
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
                    // 處理過去訂單按鈕的點擊事件
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
                    // 處理已取消訂單按鈕的點擊事件
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
          SizedBox(height: 16), // 加入間距
          Expanded(
            child: ListView.builder(
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                var order = orderList[index];
                return InkWell(
                  onTap: () {
                    // 點擊項目時的操作
                    // 您可以在這裡導航到相關頁面或執行其他操作
                  },
                  child: ListTile(
                    title: Text(order.legalName),
                    trailing: Text(order.orderDate),
                  ),
                );
              },
            ),
          ),
          NavigatorPage(), // 放在底部
        ],
      ),
    );
  }
}

class OrderInfo {
  final String legalName;
  final String orderDate;

  OrderInfo({
    required this.legalName,
    required this.orderDate,
  });
}

List<OrderInfo> orderList = [
  OrderInfo(
    legalName: '商店1',
    orderDate: '2023-08-19',
  ),
  OrderInfo(
    legalName: '商店2',
    orderDate: '2023-08-18',
  ),
  // 其他訂單資訊...
];
