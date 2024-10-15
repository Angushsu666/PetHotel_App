import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../search.dart'; 
class PaymentWebViewPage extends StatelessWidget {
  final String paymentHtmlContent;

  const PaymentWebViewPage({Key? key, required this.paymentHtmlContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(
            const PlatformWebViewControllerCreationParams());
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(paymentHtmlContent);

    return Scaffold(
      appBar: AppBar(
        title: const Text('支付頁面'),
        leading: IconButton(
          //返回鍵還沒處理好！！！！！！！！！！！！！！！！
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const SearchPage()), // 假设 SearchPage 是要返回的页面
    ModalRoute.withName('/searchPage')
  );
}
, // 使用 popUntil 返回指定页面
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
