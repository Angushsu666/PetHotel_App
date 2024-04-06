import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
        title: Text('支付成功頁面'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/searchPage')), // 使用 popUntil 返回指定页面
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
