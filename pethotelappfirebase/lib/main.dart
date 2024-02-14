import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../providers/user_provider.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/home.dart';
import '../pages/search.dart';
import '../pages/signin.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Initialize Flutter bindings first
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(
  //   ProviderScope(
  //     child: MyApp(),
  //   ),
  // );
  //看不懂
  initializeDateFormatting('zh_CN', null).then((_) {
    runApp(
      ProviderScope(
        child: MyApp(),
      ),
    ); // 替换成你的App类
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: Scaffold(body:Container(
      //   child:Text("ssssa"),
      // )),
      home: StreamBuilder<User?>(
          // Stream 會回傳 User type
          stream: FirebaseAuth.instance
              .authStateChanges(), // 等串流，這裡是firebase回傳的_auth state)
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //refresh後才不會消失？？？？？？
              ref.read(userProvider.notifier).login(snapshot.data!.email!);
              // snapshot裡面是否有User
              return SearchPage();
            }
            return SignIn();
          }),
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        titleTextStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        centerTitle: true,
      )),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:webview_flutter/webview_flutter.dart';

// class GreenWorldPaymentPage extends StatelessWidget {
//   final String merchantID = 'YourMerchantID'; // 替换为您的特店編號
//   final String hashKey = 'YourHashKey'; // 替换为您的Hash Key
//   final String hashIV = 'YourHashIV'; // 替换为您的Hash IV

//   Future<void> sendPaymentRequest(BuildContext context) async {
//     final url = Uri.parse('https://payment-stage.ecpay.com.tw/Cashier/AioCheckOut/V5');

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//         body: {
//           'MerchantID': merchantID,
//           'MerchantTradeNo': generateUniqueOrderID(),
//           'MerchantTradeDate': '2023/11/10 14:30:00',
//           'PaymentType': 'aio',
//           'TotalAmount': '1000',
//           'TradeDesc': 'Transaction Description',
//           'ItemName': 'Item Name',
//           'ReturnURL': 'https://yourwebsite.com/return', // 替换为您的ReturnURL
//           'ChoosePayment': 'ALL',
//           'CheckMacValue': 'GENERATED_CHECKMACVALUE',
//           'EncryptType': '1',
//           // 其他参数...
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         print('綠界回應：$jsonResponse');
//         // 在这里处理绿界的响应

//         // 将用户重定向到绿界支付页面
//         final paymentUrl = jsonResponse['PaymentURL'];
//         if (paymentUrl != null) {
//           Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => WebViewPage(paymentUrl),
//           ));
//         }
//       } else {
//         print('HTTP 请求错误：${response.statusCode}');
//         // 在这里处理HTTP请求错误
//       }
//     } catch (e) {
//       print('发生异常：$e');
//       // 在这里处理异常
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('绿界金流測試'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             sendPaymentRequest(context);
//           },
//           child: Text('发起支付请求'),
//         ),
//       ),
//     );
//   }
// }

// class WebViewPage extends StatelessWidget {
//   final String paymentUrl;

//   WebViewPage(this.paymentUrl);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('支付页面'),
//       ),
//       // body: WebView(
//       //   initialUrl: paymentUrl,
//       //   javascriptMode: JavascriptMode.unrestricted,
//       // ),
//     );
//   }
// }

// String generateUniqueOrderID() {
//   final now = DateTime.now();
//   final formattedDate = now
//       .toLocal()
//       .toString()
//       .split('.')
//       .first
//       .replaceAll(RegExp(r'[^0-9]'), '');
//   return 'Order_$formattedDate'; // 您可以根据需要定义更复杂的逻辑
// }

// void main() {
//   runApp(MaterialApp(
//     home: GreenWorldPaymentPage(),
//   ));
// }
