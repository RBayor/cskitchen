import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Pay extends StatelessWidget {
  final String url = "https://ravesandbox.flutterwave.com/pay/cskitchen";
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  // CookieManager.getInstance().setAcceptCookie(true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pay"),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
