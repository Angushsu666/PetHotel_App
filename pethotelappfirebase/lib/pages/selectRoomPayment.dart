import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../models/petshop.dart';

class SelectRoomPaymentPage extends ConsumerWidget {
  final petShop shop;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int numberOfNights;
  final double totalPrice;
  final String roomType;

  SelectRoomPaymentPage({
    required this.shop,
    this.checkInDate,
    this.checkOutDate,
    required this.numberOfNights,
    required this.totalPrice,
    required this.roomType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用ref来读取Provider的值
    LocalUser currentUser = ref.watch(userProvider);

    // // 弹出底部模态表单的函数
    // void _showPaymentModal() {
    //   showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return PaymentModalWidget(); // 显示底部模态表单
    //     },
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('付款資訊'),
        backgroundColor:
            const Color.fromARGB(255, 245, 206, 219), // 更改标题为“付款資訊”
      ),
      body: Column(
        children: [
          // 新增一行包含用户信息的文本
          ListTile(
              title: Text('個人資料'),
              subtitle: Text(
                '姓名: ${currentUser.user.name}\nEmail: ${currentUser.user.email} ',
                style: TextStyle(
                  fontSize: 14, // 设置字体大小
                ),
              )),
          Divider(),
          // 显示传递的信息
          ListTile(
            title: Text('商家：'),
            subtitle: Text(shop.legalName),
          ),
          ListTile(
            title: Text('房型：'),
            subtitle: Text(roomType),
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('入住日期'),
                  subtitle: Text(
                    DateFormat('MM月dd日 EEEE', 'zh_CN').format(checkInDate!),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('退房日期'),
                  subtitle: Text(
                    DateFormat('MM月dd日 EEEE', 'zh_CN').format(checkOutDate!),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          // 在Column的末尾添加一个卡片按钮
          // Column(
          //   children: [
          //     // 添加文本部分
          //     Padding(
          //       padding: const EdgeInsets.all(16.0),
          //       child: Text(
          //         '您想如何付款？',
          //         style: TextStyle(
          //           fontSize: 18, // 根据需要调整字体大小
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //     // 添加卡片按钮
          //     Card(
          //       elevation: 2, // 卡片的阴影
          //       margin: EdgeInsets.all(16), // 卡片的外边距
          //       child: ListTile(
          //         leading: Icon(Icons.add), // 添加图标
          //         title: Text(
          //           '請選擇付款方式',
          //           style: TextStyle(
          //             color: Colors.blue,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         onTap: () {
          //           _showPaymentModal(); // 显示底部模态表单
          //         },
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '費用：${totalPrice.toStringAsFixed(0)} TWD', // 显示费用
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // 处理下一步按钮点击事件
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 蓝色背景
                ),
                child: Text(
                  '立即下訂',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// // 底部模态表单的小部件
// class PaymentModalWidget extends StatelessWidget {
//   // 创建文本编辑控制器
//   final TextEditingController cardNumberController = TextEditingController();
//   final TextEditingController expiryDateController = TextEditingController();
//   final TextEditingController cvvController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     // 在这里构建底部模态表单的内容
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Text(
//             '使用新的卡片',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           // 添加付款方式选择的UI元素
//           SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: cardNumberController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(labelText: '信用卡号码'),
//                 ),
//                 TextField(
//                   controller: expiryDateController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(labelText: '有效期（MM/YY）'),
//                 ),
//                 TextField(
//                   controller: cvvController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(labelText: 'CVV 码'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // 在这里处理提交信用卡信息的逻辑
//                     // 可以将输入的信用卡信息发送到服务器等
//                     Navigator.pop(context); // 关闭底部模态表单
//                   },
//                   child: Text('提交'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }