import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatelessWidget {
  final String paymentHtmlContent;

  const PaymentWebViewPage({Key? key, required this.paymentHtmlContent})
      : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('支付页面'),
  //     ),
  //     body: WebView(
  //       initialUrl: 'about:blank',
  //       onWebViewCreated: (WebViewController webViewController) {
  //         webViewController.loadHtmlString(paymentHtmlContent);
  //       },
  //     ),
  //   );
  // }
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
        title: Text('支付页面'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
