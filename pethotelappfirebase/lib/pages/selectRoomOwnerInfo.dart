// import 'package:flutter/material.dart';
// import '../models/petshop.dart';
// import '../providers/user_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SelectRoomOwnerInfoPage extends ConsumerWidget {
//   final petShop shop;
//   final DateTime? checkInDate;
//   final DateTime? checkOutDate;
//   final int numberOfNights;
//   final double totalPrice;

//   SelectRoomOwnerInfoPage({
//     required this.shop,
//     this.checkInDate,
//     this.checkOutDate,
//     required this.numberOfNights,
//     required this.totalPrice,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentUser = ref.watch(userProvider);
//     bool isValidEmail(String email) {
//       final emailRegex =
//           RegExp(r"^[a-zA-Z0-9.!#$%&'*+-/=?^_1{|}-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
//       return emailRegex.hasMatch(email);
//     }

//     ;
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('您的個人資料'),
//           backgroundColor: const Color.fromARGB(255, 224, 160, 182),
//         ),
//         body: Column(
//           children: [
//             // 名字文本框
//             Container(
//               margin: EdgeInsets.all(12.0), // 设置外边距为12像素
//               child: TextFormField(
//                 controller: TextEditingController(text: currentUser.user.name),
//                 decoration: InputDecoration(
//                   labelText: '名字',
//                   border: OutlineInputBorder(), // 创建四边的矩形框
//                   contentPadding: EdgeInsets.all(12.0), // 设置内容内边距为12像素
//                   suffixIcon: currentUser.user.name != null
//                       ? Icon(Icons.check, color: Colors.green)
//                       : Icon(Icons.error, color: Colors.red),
//                 ),
//               ),
//             ),

//             // 邮箱文本框
//             Container(
//               margin: EdgeInsets.all(12.0),
//               child: TextFormField(
//                 controller: TextEditingController(text: currentUser.user.email),
//                 decoration: InputDecoration(
//                   labelText: '電子信箱',
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.all(12.0),
//                   suffixIcon: isValidEmail(currentUser.user.email)
//                       ? Icon(Icons.check, color: Colors.green)
//                       : Icon(Icons.error, color: Colors.red),
//                 ),
//               ),
//             ),
//             // 电话文本框
//             // TextFormField(
//             //   controller: TextEditingController(text: currentUser.user.phone),
//             //   decoration: InputDecoration(
//             //     labelText: '电话',
//             //     suffixIcon: currentUser.user.phone != null
//             //         ? Icon(Icons.check, color: Colors.green)
//             //         : Icon(Icons.error, color: Colors.red),
//             //   ),
//             // ),
//           ],
//         ));
//   }
// }
